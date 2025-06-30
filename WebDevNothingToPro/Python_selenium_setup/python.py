from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
import time

# Path to your chromedriver executable
chromedriver_path = r"C:\Users\khait\Downloads\chromedriver-win64\chromedriver-win64\chromedriver.exe"

# Set up ChromeDriver service
service = Service(executable_path=chromedriver_path)

# Create webdriver instance
driver = webdriver.Chrome(service=service)

try:
    # Open Google
    driver.get("https://www.google.com")

    # Wait for results page to load
    time.sleep(3)

    input("Press Enter to close the browser...")


finally:
    # Close browser
    driver.quit()
    
