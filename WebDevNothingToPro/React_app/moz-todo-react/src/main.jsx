import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import Image from './Images.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <Image />
  </StrictMode>,
)
