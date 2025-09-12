# Product Scraper Application

This project is a full-stack web application for scraping product data from e-commerce websites, categorizing it, and displaying it in a user-friendly interface.

---

## Features

Web Scraping – Scrapes product details (title, price, description, category, etc.) from a given URL.
Category Management – Users can select an existing category or create a new one before saving products.
Product Management– View all products in a searchable, filterable table UI.
Async Update Job – Products older than 1 week can be updated asynchronously using background jobs.
Search & Filtering – Instant search with debounce for smooth UX.

---

## Tech Stack

Backend: Ruby on Rails (API-only)   ------------------->  version (ruby - 3.4.5 / rails - 8.0.2 / node verrion - 22 )
Frontend: React + Vite + Tailwind CSS -----------------> (latest methord for ReactJs)

Background Jobs:   ActiveJob using Local , not using Sidekiq for production (in production)

Database:  MySQL

Scraping: Playwright  -(in rails i am using node above v22 (supported version) )

Deployment: (Mention if using Render, Heroku, EC2, etc.)

---

##  Setup & Installation

###  Backend Setup

```bash
# Clone repository
git clone https://github.com/thirukumaran22ravikumar/Scraping_Datas.git
cd product-scraper/backend

frontend project  - frontend (reactJs + vite + taiwind Css + node v22)
1) change version node - v22
2) npm install  
3) npm run dev  ## run



backend project  - rails (install rby  - 3.4.5)
1) install mysql and ruby 3.4.5

2) bundle install
3) rails db:create db:migrate

4) rails server






