# SpeechTimer
A simple speech timer for iOS (uses AVAudioRecorder to detect speech and time it)

Formerly "PianoControl", as can be used to calculate productive time during a piano (or any other instrument) lesson.

There are two modes available. Strict mode allows the user to set a certain amount of time (m) and when the recorder is started,
the program only counts down the time when speech is detected. In non-strict time the user sets the countdown timer, and while
it is running, the app is detecting speech in the background. When the session is over, the total "productive" time (when speech
was detected) is displayed.
