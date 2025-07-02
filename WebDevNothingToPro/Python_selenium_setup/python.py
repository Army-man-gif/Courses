from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys

import time

chromedriver_path = r"C:\Users\khait\Downloads\chromedriver-win64\chromedriver-win64\chromedriver.exe"
service = Service(executable_path=chromedriver_path)

driver = webdriver.Chrome(service=service)
driver.get("https://www.browserstack.com/guide/python-selenium-to-run-web-automation-test")
print(driver.title)
wait = WebDriverWait(driver, 10)
heading = wait.until(EC.presence_of_element_located((By.TAG_NAME, "h1")))
print("Page heading:", heading.text)


driver.quit()
