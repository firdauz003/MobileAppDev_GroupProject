<div align="center">

  <h3>KULLIYYAH OF INFORMATION & COMMUNICATION TECHNOLOGY</h3>
  <h4>INFO 4335</h4>
  <h4>Mobile Application Development</h4>

  <p>
    SEMESTER 2, 2025/2026<br>
    SECTION 1<br>
    FINAL GROUP PROJECT
  </p>

  <p>
    <b>LECTURER:</b> MOHD KHAIRUL AZMI BIN HASSAN
  </p>
  <b>PREPARED BY:</b>

</div>
<table align="center">
  <tr>
    <th>Full Name</th>
    <th>Matric Number</th>
    <th>Assigned Role</th>
  </tr>
  <tr>
    <td>Abdallah Bouher</td>
    <td>2222025</td>
    <td>Feature 5, proposal(1 to 5)</td>
  </tr>
  <tr>
    <td>Nasution Wahyu Abdillah</td>
    <td>2215447</td>
    <td>Feature 4</td>
  </tr>
  <tr>
    <td>Muhammad Firdaus Bin Zaini</td>
    <td>2217753</td>
    <td>feature 1,3</td>
  </tr>
  <tr>
    <td>Saifullah Muhammad Hafizh</td>
    <td>2225505</td>
    <td>Feature 2</td>
  </tr>
</table>

## Project Title: Mizan: Your Daily Deen & Health Companion

## 1. Introduction


Balancing daily religious obligations with a demanding university or professional schedule often leaves little room for managing personal health. While there are many standalone prayer-tracking apps and separate health-tracking apps, users often struggle to find a unified platform that helps them manage their daily prayer schedules alongside basic physical well-being, such as remembering to stay hydrated and planning simple, healthy meals throughout the week. 

Our motivation is to build a practical, all-in-one daily digital companion that bridges the gap between spiritual routines and physical health. We want to create a streamlined tool that helps busy individuals seamlessly track their daily prayers and Qibla direction, while simultaneously providing actionable support for their physical health through daily hydration tracking and a quick, ingredient-based meal finder.

This application addresses the everyday challenge of balancing religious duties with personal health, fitting naturally into the course's required Shariah-compliant domains of Healthcare and Islamic Community. From a development perspective, building this dual-purpose companion allows our team to practically apply the core concepts of this course, such as using Flutter's state management for daily health tracking and integrating Firebase for a reliable meal database.

## 2. Objectives
* **To provide accurate daily prayer management:** Implement a location-based daily timetable for all five obligatory prayers and a functional Qibla compass.
* **To promote consistent physical health:** Enable users to track their daily hydration levels against a personalized water intake goal using responsive state management.
* **To simplify daily meal planning:** Develop an ingredient-based filtering system that queries a cloud database to suggest quick, healthy meals based on what the user already has in their kitchen.
* **To deliver a seamless user experience:** Design a clean, responsive, Shariah-compliant UI using modern Flutter components, supported by secure authentication and real-time database integration.

## 3. Target Users
* **Primary Users:** Muslim university students and working professionals who need a minimalist, unified tool to balance their demanding daily schedules with their religious obligations and basic health needs.
* **Secondary Users:** General Muslim adults looking for an ad-free, straightforward application to check daily prayer times while simultaneously tracking simple health metrics like water intake and discovering quick meal ideas.

## 4. Features & Functionalities
1. **Authentication & User Profile (Firebase Auth)**
    * Secure email and password registration/login.
    * User profile setup to establish basic health parameters (e.g., daily water intake goal).
2. **Daily Deen Dashboard**
    * A dynamic home screen utilizing Flutter's `ListView` and `Card` widgets to display the daily Hijri date, a countdown timer to the next prayer, and a daily motivational Islamic quote.
3. **Prayer Times & Qibla Compass**
    * Integration of external packages (e.g., `adhan` and `flutter_compass`) to calculate accurate, offline prayer times based on the device's location and display a visually responsive Qibla direction indicator.
4. **Hydration Tracker (State Management)**
    * An interactive visual tracker utilizing a recognized state management approach (e.g., Riverpod or Provider) to allow users to add or subtract glasses of water throughout the day. The UI instantly updates the progress bar toward their daily goal.
5. **"What's in my Fridge?" Meal Finder (Cloud Firestore)**
    * A practical form utilizing checkboxes and user inputs where users select ingredients they currently have.
    * Upon submission, the app performs a Read operation from Firebase Cloud Firestore to fetch and display matching, healthy recipe cards.
  
  ## 5. UI and Mock-up

  ## 6. Technical Design 
  The application will be built using Flutter as the primary framework, ensuring cross platform compatibility for Android and iOS.

  **Widget Structure:**
  
      **Authentication Module:** Login and registration screens using textformField, ElevatedButton, and Firebase Auth Integration.
      
      **Dashboard:** Listview with Card widgets displaying prayer times, hydration progress, and motivational quoetes.
      
       **Prayer Times & Qibla Compass:** External packages (adhan, flutter_compass) intergrated into custom widgets for accurate calculations.

       **Hydration Tracker:** A CounsumerWidget and Changenotifierprovider to manage state updates in real time.

          **Meal Finder:** A form widget with checkboxes and text input, connected to Firestore queries

   **State Management Approach:** 

     **Riverpod** is choosen for its scalability and clean architecture. It allows reactive updates across multiple modules without excessive boilerplate.

**Backend Services:** 

     **Firebase Authentication** for secure login.
     **Cloud Firestore** for storing recipes and user hydration logs.

 
