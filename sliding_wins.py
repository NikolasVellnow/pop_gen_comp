from argparse import ArgumentParser

import pandas as pd

# Parse aerguments
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


df = pd.read_csv(data_file,
                 delimiter='\t')

# drop columns that are meaningless after aggregation or not needed at the moment
df = df.drop(['Major', 'Minor','hweFreq', 'Freq', 'F', 'LRT', 'p-value'], axis=1)

df['Chromo'] = df['Chromo'].astype('category')

print(df.head())
print(df.info())

grouped = df.groupby(df.Chromo)

# Create list in which info about each window will be stored
wins_list = []

# create dictionary with aggregate functions
agg_fun_dir = {'Chromo' : lambda x: x.iloc[0], # get first entry
                       'Position' : lambda x: x.iloc[0], # get first entry
                       'hetFreq' : 'mean'}

for chrom, chrom_data in grouped:
    print(chrom)
    #if chrom == "NC_031794.1":
        #print(chrom_data)

    max_pos = chrom_data['Position'].max()
    num_SNPs = len(chrom_data)
    print("# of SNPS on Chromosome: ", num_SNPs)
    print("maximal SNP position: ", max_pos)

    # initialize first window limits
    win_end = win_size
    win_start = 0

    while win_end <= max_pos:   # this leaves out remaining incomplete window at the end of chrom?
 
        win_df = chrom_data[chrom_data['Position'].between(win_start, win_end)]
        #print(win_df.info())

        n_pos = len(win_df)
        if chrom == "NC_031794.1":
            print("win_start: ", win_start, "win_end: ", win_end)
            print("number of positions: ", n_pos)
            #print(win_df)
        
        # skip windows with less than 3 SNPs
        if n_pos > 2:
            win_agg = win_df.agg(agg_fun_dir)
            win_dict = dict(win_agg)

            # add new "cols" to dict
            win_dict['win_start'] = win_start
            win_dict['win_end'] = win_end
            win_dict['n_pos'] = n_pos

            wins_list.append(win_dict)

        # slide window forwards
        win_start += step_size
        win_end += step_size

new_df = pd.DataFrame(wins_list)

print(new_df.head())

# Save DataFrame as a gzip file
new_df.to_csv(output_file,
              compression='gzip',
              sep='\t')

