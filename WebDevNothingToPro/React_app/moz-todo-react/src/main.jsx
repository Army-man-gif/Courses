import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import Alarm from './alarmAPI.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Alarm />
  </StrictMode>,
)
