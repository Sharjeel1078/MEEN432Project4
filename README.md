# MEEN432Project4
Sharjeel Abdullah's Project 4 individual repository
For MEEN 432 (Automotive Engineering)

Running the code
- Clone the GitHub repository
- Open the project folder and launch simulink.slx; and Run main.m (This initializes parameters, runs the simulation, and outputs SOC and motion results)
- Set key parameters:
- stopTime at line 120 in main.m
- Desired straight and turn velocities 
- Height and grade plot will auto-display
- To view real-time height/grade from the car’s live position:
- Open the Environment block in simulink.slx
- Use the scope inside that block

Overview
- Integrated height and grade profile into existing EV Simulink model
- Grade is calculated from the vehicle's current track position using a defined height formula
- Height profile follows this pattern:
- Logistic increase from 0 to 10 meters on the first straight
- Constant 10-meter height during the first turn
- Logistic decrease from 10 back to 0 meters on the second straight
- Flat height again on the second turn
- Grade is derived from the slope of the height function (differentiation)

Results
- A plot of the track’s full height and grade is generated
- Without grade: vehicle reaches target velocity quickly, minimal delay
- With grade: acceleration is slower due to incline resistance
- Final velocity is still achieved after passing the hill and reaching level ground

Notes
- Height/grade system works correctly and shows expected dynamic effects
- Rise time is longer due to uphill slope, confirming functionality
- Steering still has known issues on turns (same as team 5 submission mentioned by Gavin in the ReadMe)



