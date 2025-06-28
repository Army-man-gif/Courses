import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import APIs from './ThirdPartyAPI.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <APIs />
  </StrictMode>,
)
