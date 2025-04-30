import streamlit

import pandas as pd

import streamlit as st

st.title("Welcome to streamlit")

st.write("Our First DataFrame")

st.write(pd.DataFrame({'X':[1,0,2,3,4,6],'Y':[2,4,5,6,8,9]}))