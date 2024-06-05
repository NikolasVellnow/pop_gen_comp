import gzip
from argparse import ArgumentParser

# Parse aerguments
PARSER = ArgumentParser()
PARSER.add_argument("-d", "--depth_file", required=True)
# file with chromosome names to make subset for
PARSER.add_argument("-ch", "--chrom_file", required=True)


ARGS = PARSER.parse_args()
depth_file = ARGS.depth_file
chrom_file = ARGS.chrom_file

chrom_list = []
with open(chrom_file, mode='r', encoding='utf') as chr_file:
    for line in chr_file:
        chrom_list.append(line.strip())


IS_HEADER = True
IS_FIRST_LINE_FIRST_CHROM = True
IS_FIRST_LINE_NEW_CHROM = False
IS_ANOTHER_LINE_OF_CHROM = False

depth_file_without_ending = depth_file.removesuffix(".txt.gz")

###################################################################################################
with gzip.open(depth_file, mode='rt') as file:

    current_chrom = ""
    header = ""

    for line_num, line in enumerate(file):
        split_line = line.strip().split('\t')
        # ['NC_031768.1', '1088270', '51', '40', '46', '62', '63', '46', '48', '42', '56', '42']
        #print(split_line)
        if line.strip() is False:
            print("no line")
        
        IS_FIRST_LINE_NEW_CHROM = split_line[0] != current_chrom and split_line[0] in chrom_list
        IS_ANOTHER_LINE_OF_CHROM = split_line[0] == current_chrom

        #################################################################################
        if IS_HEADER:
            header = line
            IS_HEADER = False

        #################################################################################
        elif IS_FIRST_LINE_FIRST_CHROM:
            # save first chrom
            current_chrom = split_line[0]

            # create and open new file for the first chrom
            current_file_name = depth_file_without_ending + "_" + current_chrom + ".txt.gz"
            current_file = gzip.open(current_file_name, mode = 'wt')
            current_file.write(header)
            IS_FIRST_LINE_FIRST_CHROM = False
            current_file.write(line)

        #################################################################################
        elif IS_FIRST_LINE_NEW_CHROM:
            # remove old chrom from list
            chrom_list.remove(current_chrom)

            # close old file
            current_file.close()
            # gzip file

            # save new chrom
            current_chrom = split_line[0] 
            
            # create and open new file for the next chrom 
            current_file_name = depth_file_without_ending + "_" + current_chrom + ".txt.gz"
            current_file = gzip.open(current_file_name, mode = 'wt')
            current_file.write(header)
            current_file.write(line)
        #################################################################################     
        elif IS_ANOTHER_LINE_OF_CHROM:
            # write new line to current files
            current_file.write(line)

        #################################################################################
        else:
            continue



current_file.close()
