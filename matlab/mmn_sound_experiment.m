clear

% SOA, tDur, number of stimuli, pDeviant
m = mmn_sound(0.749+0.169, 0.169, 500, 0.2)
start(m)

% save audio files
% notice 500ms (Fs / 2 samples) of paddings
% audiowrite('standard.wav', [zeros(1, m.Fs / 2) m.wavStandard * 0.5 zeros(1, m.Fs / 2)], m.Fs);
% audiowrite('deviant.wav', [zeros(1, m.Fs / 2) m.wavDeviant * 0.5 zeros(1, m.Fs / 2)], m.Fs);
