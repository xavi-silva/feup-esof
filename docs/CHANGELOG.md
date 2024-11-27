# SweepSpot Changelog

* [Sprint 1](#version-100-sprint-1)
* [Sprint 2](#version-200-sprint-2)
* [Sprint 3 + Release](#version-300-sprint-3--release)

## Version 1.0.0 (Sprint 1)

### Features Added
- **User Authentication:**
  - Users can now create an account on SweepSpot, enabling access to their profiles across multiple devices;
  - Implemented the login functionality, allowing users to securely log into their accounts;
  - Added password reset feature, enabling users to regain access to their accounts;
  - Implemented email address verification for enhanced platform security and user trust.

- **Profile Page:**
  - General users now have a profile page where they can access their data.

- **Event Management:**
  - General users now are able to create events.

- **Navigation:**
  - Implemented the AppBar, which currently works on the profile and event page.

### Known Issues
- User data loading bug: After filling fields which weren't defined on the register on the profile page, the user data isn't loading;

- Navigation bug on registration: On the registration page, after writing the details of the account, sometimes it doesn't display the page 'Check email';

- Registration bug: When creating an account with an already used email, the warning shows up but the data still gets added to the database, and we are redirected to the page to add the user details.

This release marks the completion of Sprint 1, introducing essential user authentication features and event management capabilities to SweepSpot.


## Version 2.0.0 (Sprint 2)

### Features Added
- **Profile page:**
  - Users can now check their past clean-ups on profile ([#4](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/4));
  - Added feature to allow users to edit profile ([#47](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/47)).
- **Events display page:**
  - Events on the main page and open an event page ([#2](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/2));
  - Past events are now displayed on the main page ([#50](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/50)).
- **Event page:**
  - Participants can now give feedback to organizers on their events ([#7](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/7));
  - Event organizers can manage their event details from now on ([#8](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/8));
  - Added feature to allow organizers to check feedback given to their events ([#11](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/11));
  - Organizers can now provide updates after the event on their event page ([#12](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/12));
  - Users can now join and leave events ([#44](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/44));
  - Added feature to delete comments on events ([#51](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/51)).
  
- **General:**
  - "Discard" button on create event page now deletes the current photo instead of emptying all fields
  ([#41](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/41));
  - Fixed a small issue where the pop-up indicating the event was created wouldn't display correctly ([#42](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/42));
  - Implemented the Google Maps API on create event page ([#43](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/43)).

### Known Issues
- Navigation bug on registration: On the registration page, after writing the details of the account, sometimes it doesn't display the page 'Check email'([#28](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/28));
- User data loading bug: After filling fields which weren't defined on the register on the profile page, the user data isn't loading ([#37](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/37)).

- Registration bug: When creating an account with an already used email, the warning shows up but the data still gets added to the database, and we are redirected to the page to add the user details ([#40](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/40)).

This release marks the completion of Sprint 2, introducing the events display page and the majority of the features of SweepSpot.

## Version 3.0.0 (Sprint 3 + Release)

### Features Added
- **Notifications:**
  - A notification will show up on the participants' phones when an event they registered for is almost starting ([#3](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/3));
  - Participants are now notified whenever the details of their events are changed ([#6](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/6)).

- **Profile page:**
  - Clicking on the sign out button will now display a confirmation pop up before actually signing out ([#59](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/59)).

- **Event page:**
  - Implemented feature to allow admins to delete events ([#15](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/15));
  - A "Subscribed" warning will be displayed whenever a user registers for an event ([#58](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/58)).
  
- **Bug fixing:**
  - Navigation bug on registration ([#28](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/28));
  - User data loading bug ([#37](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/37));
  - Registration bug ([#40](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/40));
  - Opening event bug ([#61](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/61));
  - Add Profile Page bug ([#62](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/62)).

This release marks the completion of Sprint 3 and Release, implementing notifications, correcting bugs and refactoring SweepSpot code.

