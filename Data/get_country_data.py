import sys, getopt
import pandas as pd


def output_country_data(country):
   world_data = pd.read_csv("owid_data.csv")
   country_data = world_data.loc[world_data['country'] == country]
   if country_data.empty:
      print("Error:", country, "does not exist in the dataset")
   else:
      country_data.to_csv("./" + str(country) + "_owid_data.csv", index = False)

def main(argv):
   country = ''
   try:
      opts, args = getopt.getopt(argv,"h:c:",["country="])
   except getopt.GetoptError:
      print('get_country_data.py -c <country>')
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print('get_country_data.py -c <country>')
         sys.exit()
      elif opt in ("-c", "--country"):
         country = arg
   output_country_data(country)


if __name__ == "__main__":
   main(sys.argv[1:])