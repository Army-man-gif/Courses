
# To run locally and allow people on your WIFI network and LAN to run it:
# Use ipconfig to find "IPv4 address". Then navigate to streamlit app 
# directory then type:
# streamlit [appName].py --server.address=[IPv4 address found b4] 
# To temporarily allow anyone in the world to run it:
# Use ipconfig to find "IPv4 address". Then navigate to streamlit app 
# directory then type:
# streamlit [appName].py --server.address=[IPv4 address found b4] 
# Run the ngrok application and type ngrok http [IPv4 address found b4]:[port your streamlit is running on]
import streamlit

import pandas as pd

import streamlit as st

import matplotlib.pyplot as plt
import seaborn as sns
st.title("Welcome to streamlit")

st.write("Our First DataFrame")

st.write(pd.DataFrame({'X':[1,0,2,3,4,6],'Y':[2,4,5,6,8,9]}))

#Create button

if st.button('Click me'):
    st.write('Button was clicked!')
st.write('This is the button click event')


#Visualise data

st.title("CSV File Viewer")
st.write("Upload a CSV file a view its contents")

uploaded_file = st.file_uploader("The file",type=["csv"])
if uploaded_file is not None:
    data = pd.read_csv(uploaded_file)
    st.write("Data from uploaded CSV file: ")
    st.write(data)

    st.write("Basic stats: ")
    st.write(data.describe())

    st.subheader("Histogram visualiser")
    selected_column = st.selectbox("Select a column for the histogram",data.columns)
    plt.figure(figsize=(8, 6))
    sns.histplot(data[selected_column], kde=True)
    st.pyplot()

    st.subheader("Data Shape")
    st.write(f"The data has {data.shape[0]} rows and {data.shape[1]} columns")

    st.subheader("Data information")
    st.dataframe(data.info())