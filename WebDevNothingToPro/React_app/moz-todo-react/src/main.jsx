import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import three from './three.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <three />
  </StrictMode>,
)
