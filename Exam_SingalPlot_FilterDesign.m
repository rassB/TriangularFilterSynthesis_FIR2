%% Ce travail a pour but : 
%{
-De montrer d'un filtre FIR en forme arbitraire (triangulaire dans l'exemple), 
par la méthode d'echentillonage fréquentiel, et utilisation de la fonction FIR2

-Filtrer le signal x(t) par le filtre designé par la méthode décrite
ci-dessus.

-Ce programme sera accompagné d'une petite interface graphique permettant
la manipulation facile des parametres.

%} 
%% Avantages et inconvénients de la méthode :
%{
-L'inconvénient est de devoir prendre en considération la longueur du
programme (les tailles des vecteurs) casse tête a programmer. 

-Possibilitée de créer des FIR de trés grand ordre sans trop de calcules
une fois le programme réalisé.
-Possibilitée de visionner l'effet du filtre facilement et interactivement 
une fois le travail fait.

%}
%% Initialisation du Workspace
clear; 
close all; 
clc; 
%% Parametres manipulation facile du filtre. 

fe=1000;           % sampling frequency
ordre=1000;       %ordre du filtre
decalage=100;      % de la forme triangulaire
largeur=100;       % de la forme triangulaire

%% Remarques 

%{
-A l'ordre 10, la facteur de qualité du filtre est trop bas, 
la coupure pas assez franche, et donne des gains faibles pour la freq centrale.
ce probléme s'arrange pour des ordres >100.

-La FFT affiche bien des Sinc, dont la largeur est faible par rapport a la
hauteur, ils apparaissent donc comme de fines impulsions, un zoom permet de
s'apercevoir que ce sont effectivement des Sinc. (image zoomée fournie dans le
dossier)

%}

%% Afficheage du signal a filtrer 

t=0:(1/fe):(250-1/fe); %création de l'echelle de temps par rapport a fe
x=0.02*cos((200*pi*t)).*rectpuls((t-100),200); %rectpuls crée un signal porte de taille 200 centré sur 100.

figure(1) 
subplot(3,2,1) %plot du signal x(t)
plot(t,x)
axis([0 250 -0.03 0.03])
ylabel('x(t) (V)') 
xlabel('t (s)') 

%% Afficheage de la FFT du signal a Filtrer

n = length(x);  %n, la taille du signal nous sera utile par la suite.
X = fft(x);     % calcule de x(f) la fft de x(t)
f = (0:n-1)*(fe/n); %frequency range %creation de l'echelle des frequences par rapport a n

figure(1) 
subplot(3,2,5)        %Plot de |x(f)| la FFT(x(t))
Y = fftshift(X);      %Décalage a 0 des frequences pour avoir un afficheage equivalent a celui de la théorie

feShift = (-n/2:n/2-1)*(fe/n);  % zero-centered frequency range
powershift = abs(Y)/fe;         % normalisation des puissances

plot(feShift,powershift)
%axis([0 50 0 0.00005]) %Option a activer pour juger du bruit sur la plage [0,50], il est nécessaire de l'activer sur l'autre plot des fft en bas pour comparer
ylabel('|x(f)| (V/Hz)') 
xlabel('f (Hz)') 

%% Creation de la forme (triangulaire)

tri = tripuls(f-2*decalage,largeur); 
%{

triplus déssine un triange décalé de 
"2*décalage" et de largeur "largeur" sur l'axe f.
le décalage doublé car il est converti en décalage de pulsation w/pi(rad/s) 
car fir2 prend rad/echentillon en argument 

%}

figure(1)
subplot(3,2,3) %plot de la forme du filtre idéal.
plot(f,tri);
ylabel('|H(f)| (Gain linéaire)') 
xlabel('Décalage en pulsations (rad/s)') 

%% Design du filtre 

coef=fir2(ordre,linspace(0,1,n),tri); 
%{
coef seront les ordre+1 coefficients du filtre en forme tri, sur l'axe des
pulsations normalisées linspace(0,1,n).
%}

figure(2)
freqz(coef); % affichera le plot d'amplitude et de déphasage du filtre.

[h,w]=freqz(coef);

figure(1)
subplot(3,2,4) %afficheage du gabarit du filtre réel.
plot(w/pi,(abs(h)),'red')
ylabel('|H(f)| (Gain linéaire)') 
xlabel('w/pi (rad/echantillon)') 

%% Filtrage

filtered=filter(coef,1,x); %calcule du nouveau signal filtré par le FIR défini par ses coef

figure(1)
subplot(3,2,2) % plot du signal filtré a droite du signal original.
plot(t,filtered)
axis([0 250 -0.03 0.03])
ylabel('Filtered x(t) (V)') 
xlabel('t (s)') 

n2 = length(filtered);
X2 = fft(filtered);

figure(1) %plot de la FFT du signal filtré
subplot(3,2,6)
Y2 = fftshift(X2);
feShift2 = (-n2/2:n2/2-1)*(fe/n2);  % zero-centered frequency range
powershift2 = abs(Y2)/fe;           % zero-centered power
plot(feShift2,powershift2)
%axis([0 50 0 0.00005]) %Option a activer pour juger du bruit sur la plage [0,50], il est nécessaire de l'activer sur l'autre plot des fft en bas pour comparer
ylabel('Filtered |x(f)| (V/Hz)') 
xlabel('f (Hz)') 