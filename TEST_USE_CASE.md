# 🧪 StreakAura Test Use Case

## **Scenario: Alex - College Student Building Study Habits**

Follow this step-by-step test case to experience the full MVP flow:

---

## **Step 1: First Launch & Empty State**
1. ✅ Launch the app
2. ✅ You should see:
   - Aura Score ring showing **0** with "Dim 🌑" label
   - Message: "No habits yet. Tap + to add one!"
   - Tagline: "Your Daily Glow, One Streak at a Time"
3. ✅ Notice the dark theme with liquid glass aesthetic

---

## **Step 2: Add Your First Habit**
1. ✅ Tap the **+ (FAB)** button (bottom right)
2. ✅ Fill in the form:
   - **Name**: "Read 20 mins" 📚
   - **Emoji**: Tap emoji field, select 📚 (or type it)
   - **Description**: "Daily reading for exam prep" (optional)
   - **Frequency**: Keep "Daily" selected
   - **Weekly Goal**: Leave at 7 (for daily habits)
3. ✅ Tap **"Add Habit"** button
4. ✅ You should return to home screen

---

## **Step 3: View Your Habit & Aura Score**
1. ✅ Home screen now shows:
   - **Aura Score Ring** at the top (should show a low score ~10-20)
   - Your habit card with:
     - 📚 Read 20 mins
     - Current Streak: 0 days 🔥
     - Longest: 0 days
     - Circular check-in button (unchecked)
2. ✅ Notice the liquid glass card design with frosted effect

---

## **Step 4: Check In Your Habit**
1. ✅ Tap the **circular button** on the right of your habit card
2. ✅ You should see:
   - **Ripple animation** expanding from the button
   - Button turns **teal** with a checkmark ✓
   - Button has a **glowing shadow** effect
   - Streak updates to "Current Streak: 1 days 🔥"
   - **Aura Score increases** (ring animates upward)
3. ✅ Tap again to **uncheck** (removes today's check-in)

---

## **Step 5: Add More Habits (Test Free Limit)**
1. ✅ Add a second habit:
   - **Name**: "Exercise 30 mins" 🏃
   - **Emoji**: 🏃
   - **Frequency**: Daily
2. ✅ Add a third habit:
   - **Name**: "Meditate 10 mins" 🧘
   - **Emoji**: 🧘
   - **Frequency**: Daily
3. ✅ Try to add a **4th habit**:
   - You should see a **Premium required** dialog
   - Message: "Free plan allows 3 habits. Upgrade to add more."
   - Options: "Not now" or "Upgrade" (paywall not implemented yet)

---

## **Step 6: Build a Streak**
1. ✅ Check in all 3 habits for **3 consecutive days**
   - Each day, tap all 3 check-in buttons
   - Watch the Aura Score increase
2. ✅ After 3 days, you should see:
   - All habits showing "Current Streak: 3 days 🔥"
   - Aura Score around **60-80** (depending on consistency)
   - Label changes to "Shining 💫" or "Glowing ✨"

---

## **Step 7: Test Weekly Habit**
1. ✅ Edit one habit (long-press or add edit functionality):
   - Change "Meditate 10 mins" to **Weekly**
   - Set **Weekly Goal** to 3
2. ✅ Check it in 3 times over the week
3. ✅ Notice how Aura Score adjusts for weekly vs daily habits

---

## **Step 8: Explore Settings**
1. ✅ Tap the **⚙️ Settings** icon (top right)
2. ✅ Settings screen shows:
   - **Premium Status Card**:
     - Shows "Free Plan"
     - Displays "3/3 habits"
     - "Upgrade to Premium" button (shows snackbar for now)
   - **Export & Backup**:
     - "Export Habit Report" (Premium feature)
     - Tapping shows: "Upgrade to Premium to export reports"
   - **About**:
     - App Version: 1.0.0
     - Made with ❤️ tagline

---

## **Step 9: Test Premium Export (If Premium Enabled)**
*Note: Premium gate is currently set to `false` by default. To test:*
1. ✅ Temporarily set `PremiumGate.isPremium = true` in code
2. ✅ Go to Settings → Export Habit Report
3. ✅ PDF should generate and open print/share dialog
4. ✅ PDF contains:
   - Habit names, emojis
   - Creation dates
   - Current & longest streaks
   - Total check-ins

---

## **Step 10: Visual Polish Check**
1. ✅ Scroll the home screen - notice smooth scrolling
2. ✅ Check-in animations - ripple effect on tap
3. ✅ Aura Score ring - animated fill when score changes
4. ✅ Card shadows - frosted glass effect
5. ✅ Color scheme:
   - Deep Indigo (#5E17EB) for primary
   - Electric Teal (#00D1FF) for accents
   - White text on dark background

---

## **Expected Behaviors**

### ✅ **Working Features:**
- Add/Edit habits with emoji, name, frequency
- Daily/Weekly habit toggle
- Check-in with ripple animation
- Streak calculation (current & longest)
- Aura Score calculation (0-100)
- Aura Score ring with animated fill
- Free plan limit (3 habits)
- Premium gate UI
- Settings screen
- PDF export (premium, requires enabling)

### ⚠️ **Not Yet Implemented:**
- Reminder notifications (scaffold exists)
- Home/Lock screen widgets
- RevenueCat paywall integration
- Cloud sync (Firebase)
- Habit templates
- Onboarding flow

---

## **Success Criteria**

After completing this test case, you should have:
1. ✅ Created 3 habits
2. ✅ Built a 3+ day streak
3. ✅ Seen Aura Score increase from 0 to 60+
4. ✅ Experienced smooth animations
5. ✅ Tested premium gate
6. ✅ Explored all screens

---

## **Quick Test Checklist**

- [ ] App launches without errors
- [ ] Empty state shows Aura Score ring
- [ ] Can add habit with emoji
- [ ] Check-in button works with ripple
- [ ] Streak updates correctly
- [ ] Aura Score calculates and displays
- [ ] Free limit blocks 4th habit
- [ ] Settings screen accessible
- [ ] Animations are smooth
- [ ] UI matches liquid glass aesthetic

---

**Happy Testing! 🌟**

*If you find any issues, note them down for the next iteration.*

