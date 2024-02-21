import gzip
import math
from argparse import ArgumentParser

import numpy as np
import pandas as pd

# Parse arguments
PARSER = ArgumentParser()
PARSER.add_argument("-i", "--input_file", required=True)
PARSER.add_argument("-ws", "--window_size",
                    required=False, default=10000, type=int)
PARSER.add_argument("-st", "--step_size",
                    required=False, default=5000, type=int)
PARSER.add_argument("-o", "--output_file", required=True)
ARGS = PARSER.parse_args()

data_file = ARGS.input_file
win_size = ARGS.window_size
step_size = ARGS.step_size
output_file = ARGS.output_file


def extract_sample_name_from_path(path: str) -> str:
    """ Parses annoying path and extracts only the sample/sequencing id"""
    sample_file_name_or_folder = path.strip().split('s/')[1]
    sample_name = sample_file_name_or_folder.split('_')[0]
    return sample_name


def get_header_list(dat_file):
    """Get samples from first line""" 
    with gzip.open(dat_file, mode='rt') as this_file:
        this_line = this_file.readline()
        splitted_line = this_line.strip().split('\t')
        first_two_cols = splitted_line[0:2]
        first_two_cols = [x.strip('#') for x in first_two_cols]
        sample_path_list = splitted_line[2::]
        sample_list = [extract_sample_name_from_path(p) for p in sample_path_list]

        header_list = first_two_cols + sample_list

        return header_list, sample_list

        #n_samples = len(sample_list)


def process_data_inside_win(splitted_line, cumulative_sums):
    """Process data while being inside window"""
    values = splitted_line[2::]

    depths_per_site = [int(value) for value in values]

    # add depth values to cumulative sum
    cumulative_sums = [sum(x) for x in zip(depths_per_site, cumulative_sums)]

    return(cumulative_sums)

def process_data_end_of_win(cumulative_sums, num_positions, window_list, sample_list):
    """process data collected from window"""
    #print("#################################")
    window_dict = {}
    # calculate means
    means = [cum_sum/num_positions for cum_sum in cumulative_sums]
    # save window data
    window_dict['CHROM'] = chrom_id
    window_dict['win_start'] = win_start
    window_dict['win_end'] = win_end
    dat_dict = dict(zip(sample_list, means))
    window_dict = window_dict | dat_dict
    window_list.append(window_dict)

    return window_list


def insert_first_entry(splitted_line, cumulative_sum):
    """Insert data from pos (now first entry) into cum_sums_of_depths"""
    values = splitted_line[2::]
    depths_per_site = [int(value) for value in values]
    # add depth values to cumulative sum
    cumulative_sum = [sum(x) for x in zip(depths_per_site, cumulative_sum)]
    return cumulative_sum

n_samples = 0
sampl_list = []
headr_list = []
chrom_id = ""

# Get samples from first line
headr_list, sampl_list = get_header_list(data_file)

n_samples = len(sampl_list)
win_start = 0
win_end = win_size
wins_list = []

counter = 0
num_pos_in_win  = 0
cum_sums_of_depths = [0 for val in range(n_samples)]

# Process values

with gzip.open(data_file, mode='rt') as file:


    for line in file:
        split_line = line.strip().split('\t')
        if line.strip() is False:
            print("no line")
        first_entry = str(split_line[0])

        # skip processing in header line
        if first_entry == "#CHROM":
            #sampl_list = split_line[2::]
            continue
        
        pos = int(split_line[1])

        # if we reached a new chromosome
        if first_entry != chrom_id:

            if chrom_id != "":
            # process last remaining data from previous chromosome
                wins_list = process_data_end_of_win(cum_sums_of_depths, num_pos_in_win, wins_list, sampl_list)
                cum_sums_of_depths = [0 for val in range(n_samples)]

            chrom_id = first_entry
            num_pos_in_win = 0
            # start windows again from beginning
            win_start = 0
            win_end = win_size


            # if the current position is inside current window
            if win_start <= pos < win_end:
                cum_sums_of_depths = process_data_inside_win(split_line, cum_sums_of_depths)
                num_pos_in_win += 1
            
            # if current position is behind current window
            elif pos >= win_end:
                
                # calculate next window
                while pos >= win_end:
                    win_start += step_size
                    win_end = win_start + win_size

        # we are still in old chromosome
        elif first_entry == chrom_id:

            # data processing inside window (= current pos in window)
            if win_start <= pos < win_end:
                cum_sums_of_depths = process_data_inside_win(split_line, cum_sums_of_depths)
                num_pos_in_win += 1

            # when we reach new window (= current pos behind window)
            elif pos >= win_end:
                wins_list = process_data_end_of_win(cum_sums_of_depths, num_pos_in_win, wins_list, sampl_list)
                cum_sums_of_depths = [0 for val in range(n_samples)]

                # calculate next window
                while pos >= win_end:
                    win_start += step_size
                    win_end = win_start + win_size
                
                cum_sums_of_depths = insert_first_entry(split_line, cum_sums_of_depths)
                num_pos_in_win = 1


# add data from last window
wins_list = process_data_end_of_win(cum_sums_of_depths, num_pos_in_win, wins_list, sampl_list)      

new_df = pd.DataFrame(wins_list)

print(new_df.head(6))

# Save DataFrame as a gzip file
new_df.to_csv(output_file,
              compression='gzip',
              sep='\t')