# SweepSpot Feedback

* [Sprint 1](#sprint-1)
* [Sprint 2](#sprint-2)
* [Sprint 3 + Release](#sprint-3--release)

## Sprint 1

### Feedback given by the teacher on previous sprint

- **Product vision statement:**
  - It’s a good product vision, but consider condensing each sentence.
  
- **Domain modelling:**
  - Add labels to relationships;
  - I’m imagining the user should be able to make multiple reviews (just not multiple to the same event), consider revising multiplicities there or creating an association class.
- **Acceptance tests:**
  - Review how explicit the given/when/then parts of the AT are with example information.

- **Physical architecture UML:**
  - The server doesn't have a UI, but it can have connection endpoints. Does the server talk to the google maps or is it the device that does that?

- **Delivery:**
  - The APK has been delivered, but the tag should have been a release.
 
- **Project Management:**
  - Make sure the board is ordered;
  - Labels are hidden, confirm that everything is properly ordered.

### Product Backlog Adjustments
- **New user stories:**
  - As a general user, I want to reset the password for my account, so that I can regain access to my account ([#26](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/26));
  - As a general user, I want my email address to be verified, so that I can trust the platform's security ([#27](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/27)).

- **New bugs:**
  - Discard event bug ([#36](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/36)).

- **Feedback related tasks:**
    - Product Vision Feedback ([#29](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/29));
    - Domain Modelling Feedback ([#30](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/30));
    - Acceptance Tests Feedback ([#31](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/31));
    - Physical Architecture UML Feedback ([#32](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/32));
    - Delivery Feedback ([#34](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/34));
    - Product Backlog Feedback ([#35](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/35)).
    
## Sprint 2

### Feedback given by the teacher on previous sprint

- **Sprinting:**
  - SBIs are supposed to be assigned only when an item moves to in progress.
  
- **Product Backlog Refinement:**
  - Acceptance tests were written inline, without any linked .feature files.
- **Product Increment:**
  - Release text outlines changes, but there are no links to issues or PRs;
  - CHANGELOG.md looks good, but it should have links as well.

- **Sprint Review:**
  - Feedback was not recorded in repository;
  - There were no notes on how the Product Backlog should be adapt.

- **General:**
  - Place field names above the input box instead of inside;
  - Replace the "In review" column for the "Accepted" on Backlog;
  - Action items should be more specific;
  - "Discard" button on 'create event page' should only remove photo instead of clearing all fields.

### Product Backlog Adjustments
- **New user stories:**
  - As an organizer I want to input an address and visualize it on a map when creating an event, so that I am sure the address it correct ([#43](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/43));
  - As a general user, I want to join and leave events so that organizers are aware of the number of people that will show up ([#44](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/44));
  - As a general user I want to edit my profile details so that I can change my photo if I want to ([#47](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/47));
  - As a general user I want to see past events on the main page so that I can check the details of events I didn't attend ([#50](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/50));
  - As a general user I want to delete my comments so that I can correct myself if I mispronouced myself ([#51](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/51)).

- **New bugs:**
  - Create event bug ([#42](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/42));
  - Comments display bug ([#46](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/46)).

- **Feedback related tasks:**
  - Fix "discard" button on "create event" page ([#41](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/41));
  - Placing field names above the input box instead of inside ([#52](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/52));
  - Linking .feature files to issues ([#53](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/53));
  - Recording feedback and product backlog updates on repository ([#54](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/54));
  - Replacing the "In review" column for the "Accepted" on Backlog ([#55](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/55));
  - Adding links to issues on CHANGELOG.md ([#56](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/56)).



## Sprint 3 + Release

### Feedback given by the teacher on previous sprint
- **Sprinting:**
  - Ideally you'd be assigning items to pairs or trios.
  
- **Product Backlog Refinement:**
  - User stories should have mockups.

- **General:**
  - Add a confirmation pop-up after clicking on the "Sign out" button;
  - Add a "Subscribed" warning to the event page (besides the icon change).

### Product Backlog Adjustments
- **New tasks:**
  - Clean and refactor the code ([#63](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/63)).

- **New bugs:**
  - Opening event bug ([#61](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/61)) [SOLVED];
  - Add Profile Page bug ([#62](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/62)) [SOLVED].

- **Feedback related tasks:**
  - Add a "Subscribed" warning to the event page ([#58](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/58));
  - Add a confirmation pop-up before sign out ([#59](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/59));
  - Add mockups to the remaining user stories ([#60](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/60)).

- **Discontinued features:**
  - [**USER STORY**] As a clean-up event organizer, I want to get notified upon new entries on my event, so that I am able to plan the logistics ahead of schedule ([#9](https://github.com/FEUP-LEIC-ES-2023-24/2LEIC14T4/issues/9)): During the implementation of this feature, we determined that events with large attendance would generate an excessive number of notifications for the organizer. Consequently, we decided to discontinue its development.


