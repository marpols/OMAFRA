# Code created by Mariaelisa Polsinelli for OMAFRA ONvegetables blog 2022
# *****
# Generates html code that can be pasted into wordpress for VCR posts
# requires numerical values only in new .xlsx file with no headings or row labels
# data should be listed in same order as county_list and pest objects appended to pest_list


import pandas as pd
import openpyxl

#If pasting a path/file address remember '\' need to be changed to '/'
table_file = 'C:/Users/Maria/Documents/OMAFRA 2022/Data files 2022/pesttable4html.xlsx'

class Pest:
    #Defines class with variables name (str) and threshold ranges (tuple of tuples)
    #e.g. a range of 25-200 would be (25,100)
    #a threshold greater than a single number would be a tuple of length 1
    #e.g 128+ would be (128, )

    def __init__(self, name, threshold_ranges):
        self.name = name
        self.threshold_ranges = threshold_ranges

def check_thresh(num,pos):
#takes number and checks if falls above or within a pest threshold range
#num(int) - pest threshold value
#pos(int) - index of value in main dataframe (pest_table)
    at_threshold = False
    for t in pest_list[pos].threshold_ranges:
        if type(t) == int:
            if num >= t:
                at_threshold = True
        elif type(t) == tuple:
            if t[0] <= num <= t[1]:
                at_threshold = True
    return at_threshold

pest_list = []
county_list = ["Essex*", "Chatham-Kent*","Norfolk**","Huron***","Wellington**","Simcoe County***",
               "Durham***","Peterborough","Kemptville***","Sudbury***" ]

pest_list.append(Pest("Carrot Rust Fly", [(329, 395), (1399, 1711)]))
pest_list.append(Pest("Onion Maggot", [(210, 700), (1025, 1515)]))
pest_list.append(Pest("Carrot Weevil", [(138, 156), 455]))
pest_list.append(Pest("Aster Leafhopper", [128]))
pest_list.append(Pest("Tarnished Plant Bug", [40]))
pest_list.append(Pest("Cabbage Maggot", [(314, 398), (847, 960), (1446, 1604)]))
pest_list.append(Pest("Seedcorn Maggot", [(200, 350), (600, 750), (1000, 1150)]))
pest_list.append(Pest("European Corn Borer", [1000000]))

table_start = "<figure class=\"wp-block-table\"><table><tbody><tr><td>County</td>"
threshold_row = "<tr><td>THRESHOLD</td><td>329-395, 1399-1711</td><td>210-700, 1025-1515</td>" \
                "<td>138-156, 455+</td><td>128+</td><td>40+</td><td>314-398, 847-960, 1446-1604</td>" \
                "<td>200-350, 600-750, 1000-1150</td><td>See legend below</td></tr>"
table_end =  "</tbody></table></figure>"
row_start = "<tr>"
row_end = "</tr>"
cell_start = "<td>"
cell_end = "</td>"
threshold = "<span style=\"color:#c71212\" class=\"has-inline-color\"><strong>"
end_thresh = "</strong></span>"
wp_table = table_start

pest_table = pd.read_excel(table_file, index_col=None, header=None)

for pest in pest_list:
    #generate pest header
    wp_table = wp_table + cell_start + pest.name + cell_end

wp_table = wp_table + row_end + threshold_row

new_row = True
i = 0

#populate table
for index, row in pest_table.iterrows():
    if new_row == True:
        wp_table = wp_table + row_start + cell_start + county_list[index] + cell_end
        new_row = False
    while i < len(row):
            tstat = check_thresh(row[i], i)
            if tstat == True:
                wp_table = wp_table + cell_start + threshold + str(round(row[i])) + end_thresh + cell_end
            else:
                wp_table = wp_table + cell_start + str(round(row[i])) + cell_end
            i += 1
    wp_table = wp_table + row_end
    new_row = True
    i = 0

wp_table = wp_table + table_end
print(wp_table)

html_file = open("C:/Users/Maria/Documents/OMAFRA 2022/Data files 2022/wp_pesttable_html.txt", "w")
html_file.write(wp_table)
html_file.close

#if __name__ == "__main__":
