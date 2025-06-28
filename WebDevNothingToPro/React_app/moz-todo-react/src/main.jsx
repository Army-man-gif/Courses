import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import BasicAnimation from './BasicsCSSAnimation.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BasicAnimation />
  </StrictMode>,
)
