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
driver.get("https://www.google.com")
print(driver.title)

wait = WebDriverWait(driver, 10)

try:
    # Check for consent iframe
    iframe = wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "iframe[src*='consent']")))
    print("Consent iframe FOUND")
    print("Iframe src:", iframe.get_attribute('src'))
    
    # Let's switch inside the iframe and print all buttons text (to inspect what is there)
    driver.switch_to.frame(iframe)
    buttons = driver.find_elements(By.TAG_NAME, "button")
    print(f"Found {len(buttons)} buttons inside consent iframe:")
    for i, btn in enumerate(buttons):
        print(f" Button {i+1}: text='{btn.text}', aria-label='{btn.get_attribute('aria-label')}'")
    driver.switch_to.default_content()
except Exception as e:
    print("Consent iframe NOT found or error:", e)
    driver.switch_to.default_content()

# Now check if search bar is clickable
try:
    search_bar = wait.until(EC.element_to_be_clickable((By.NAME, "q")))
    print("Search bar is clickable")
    overlays = driver.find_elements(By.CSS_SELECTOR, "div[style*='overlay']")
    print(f"Overlays found: {len(overlays)}")
    for overlay in overlays:
        driver.execute_script("arguments[0].style.display = 'none';", overlay)
    search_bar.clear()
    search_bar.send_keys("Smiley face")
    search_bar.send_keys(Keys.RETURN)
except Exception as e:
    print("Search bar NOT clickable or error:", e)

driver.quit()
