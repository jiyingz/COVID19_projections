# COVID-19 Case Predictions

We model the number of deaths and severe cases by country for COVID-19 and make projections for the next 2 months. Our novel SELICRD model is an extended version of the common epidemiological SIR model for infectious disease progression. Briefly, the model considers country-specific values for population, hospital bed capacity, and R0 over time. Separate sub-models are used to estimate R0 and severe case counts. 

This is a project done for a course at Stanford University (CS472: Data Science and AI for COVID-19) in partnership with Genentech, Inc. during the Spring 2020 quarter, in the midst of the 2020 COVID-19 pandemic. We are thankful for inspiration from models by Henri Froese (https://towardsdatascience.com/infectious-disease-modelling-fit-your-model-to-coronavirus-data-2568e672dbc7) and Michael Li (https://www.covidanalytics.io/DELPHI_documentation_pdf). 

The final writeup can be accessed in the file `COVID19_SELICRD_Predictions_Final_Writeup.pdf`.


## How to use models

**Data:** Our data sources are enumerated in Section 3 of our report and within the individual scripts.  

The data used for the most recent script run is contained within the `/Data` folder. This data was last updated on 6/10/2020. 

**Model Diagram:** For those familiar with the SIR model, a model flow diagram for the SELICRD model is available in `SELICRD_model_diagram.png`.

**Main Script:** It is possible to make predictions for other regions and countries given data on population count, number of hospital beds, number of deaths, and number of severe (critical care/ICU) cases. 

The script to run the SELICRD, time-changing R0, and SLSC models is `full_model.ipynb` and is written in Python 3. This script contains the full pipeline from modeling to validation and making projections.

**Projections:** Predictions for the number of severe cases for the next 2 months for chosen countries are available as CSV files in the folder `/Projections`.




