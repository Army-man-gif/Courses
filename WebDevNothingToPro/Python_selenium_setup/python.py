from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Path to your chromedriver executable
chromedriver_path = r"C:\Users\khait\Downloads\chromedriver_win32\chromedriver.exe"

# Set up ChromeDriver service
service = Service(executable_path=chromedriver_path)

# Create webdriver instance
driver = webdriver.Chrome(service=service)

try:
    # Open Google
    driver.get("https://www.google.com")

    # Find the search input box by its name attribute
    search_box = driver.find_element(By.NAME, "q")

    # Type a query and hit Enter
    search_box.send_keys("Selenium Python tutorial")
    search_box.send_keys(Keys.RETURN)

    # Wait for results page to load
    time.sleep(3)

    # Print the title of the page
    print("Page title:", driver.title)
    input("Press Enter to close the browser...")


finally:
    # Close browser
    driver.quit()