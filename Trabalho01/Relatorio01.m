%% ========================================================================
%  Trabalho 1 - Processamento Digital de Sinais
%  Victor J Teixeira
%  MatLab/Octave aplicado ao PDS
%
%  IMPORTANTE: Antes de rodar, coloque este arquivo .m DENTRO da pasta
%  "Arquivos_Trabalho1" (ou ajuste o caminho na variável "pasta_arquivos"
%  abaixo) para que os arquivos musica.wav, teste.bmp e teste1.bmp sejam
%  encontrados automaticamente.
% ========================================================================

clear all; close all; clc;

% Pasta onde estao os arquivos de audio/imagem
pasta_arquivos = 'Arquivos_Trabalho1';

% Se este script NAO estiver dentro da pasta, descomente a linha abaixo
% para adicionar a pasta ao path do MatLab/Octave:
% addpath(pasta_arquivos);


%% ========================================================================
%  2 - OPERACOES COM VETORES
% ========================================================================

%% 2.1 - Vetor x de 0 a 25, passo 1
x = 0:1:25;
disp('Vetor x:'); disp(x);

%% 2.2 - Vetor y de 24 a 0, passo 1 (decrescente)
y = 24:-1:0;
disp('Vetor y:'); disp(y);

%% 2.3 - Vetor z de 100 elementos usando x, y e zeros
z = zeros(1,100);
n = 0:99;
z(1:26) = x;      % primeiros 26 elementos recebem x (0..25)
z(27:51) = y;     % elementos 27 a 51 recebem y (24..0)
% os elementos de 52 a 100 permanecem em zero (definidos por zeros())

figure;
plot(n,z);
axis([-2 100 -1 30]);
grid;
title('2.3 - Sinal z(n) formado por x e y, com zeros no restante');
xlabel('n'); ylabel('z(n)');

% Comentario (a incluir no relatorio):
% - z = zeros(1,100) cria um vetor de 100 zeros.
% - z(1:26) = x insere a rampa crescente (0 a 25) nas 26 primeiras posicoes.
% - z(27:51) = y insere a rampa decrescente (24 a 0) nas posicoes 27 a 51.
% - As posicoes 52 a 100 continuam zero, formando um "patamar" no grafico.
% - O resultado e um sinal triangular seguido de um trecho nulo.


%% 2.4 - Vetor zp com 3 periodos de z, usando stem()
zp = [z z z];
np = 0:length(zp)-1;

figure;
stem(np, zp);
title('2.4 - Sinal periodico zp (3 periodos de z)');
xlabel('n'); ylabel('zp(n)');

% Calculo do periodo fundamental e frequencia fundamental
Fs = 8000;                 % frequencia de amostragem (Hz)
N_periodo = length(z);     % periodo fundamental em amostras (100 amostras)
T0 = N_periodo / Fs;       % periodo fundamental em segundos
f0 = Fs / N_periodo;       % frequencia fundamental em Hz

fprintf('Periodo fundamental: %d amostras (%.6f s)\n', N_periodo, T0);
fprintf('Frequencia fundamental: %.2f Hz\n', f0);

% Comentario (a incluir no relatorio):
% - O periodo fundamental de z e de 100 amostras (comprimento de z).
% - Como Fs = 8000 Hz, o periodo fundamental em tempo e T0 = 100/8000 = 12.5 ms
% - A frequencia fundamental e f0 = Fs/N = 8000/100 = 80 Hz.


%% ========================================================================
%  3 - OPERACOES COM MATRIZES
% ========================================================================

%% 3.1 - Definicao das matrizes
A = [2 3 4 ; 4 4 4 ; 8 9 0];
C = [1 2 ; 3 4 ; 1 1];
disp('Matriz A:'); disp(A);
disp('Matriz C:'); disp(C);

%% 3.2 - Multiplicacao A*C
AC = A*C;
disp('A*C ='); disp(AC);

% Tentando C*A (para verificar comutatividade)
try
    CA = C*A;
    disp('C*A ='); disp(CA);
catch erro
    fprintf('Erro ao calcular C*A: %s\n', erro.message);
end

% Comentario (a incluir no relatorio):
% - A multiplicacao de matrizes NAO e comutativa em geral (A*C ~= C*A).
% - Alem disso, aqui C*A nem sequer e possivel: A e 3x3 e C e 3x2, entao
%   A*C e valido (3x3 * 3x2 = 3x2), mas C*A exigiria que o numero de
%   colunas de C (2) fosse igual ao numero de linhas de A (3), o que nao
%   ocorre. Isso ilustra que, alem de nao comutativa, a multiplicacao de
%   matrizes exige compatibilidade de dimensoes.


%% 3.3 - Multiplicacao elemento a elemento A.*C e A.*D
% Observacao: A e 3x3 e C e 3x2, entao A.*C NAO e valida (dimensoes
% incompativeis para operacao elemento a elemento). Por isso, usamos
% try/catch para mostrar o erro esperado.
try
    AtimesC = A.*C;
    disp('A.*C ='); disp(AtimesC);
catch erro
    fprintf('Erro ao calcular A.*C (dimensoes incompativeis): %s\n', erro.message);
end

D = ones(3,3);
AtimesD = A.*D;
disp('D = ones(3,3):'); disp(D);
disp('A.*D ='); disp(AtimesD);

% Comentario (a incluir no relatorio):
% - A.*C falha pois .* exige que as matrizes tenham as MESMAS dimensoes
%   (A e 3x3, C e 3x2).
% - D = ones(3,3) e uma matriz 3x3 de uns, com as mesmas dimensoes de A.
% - A.*D multiplica cada elemento de A pelo elemento correspondente de D
%   (que e sempre 1), portanto A.*D = A. A operacao .* e a multiplicacao
%   elemento a elemento (Hadamard), diferente da multiplicacao matricial *.


%% 3.4 - Matriz M 1500x1500, multiplicar por 5 usando FOR x M*5
M = ones(1500,1500);

% Metodo 1: usando FOR (dois lacos, percorrendo linha e coluna)
tic;
M_for = M;
for i = 1:size(M,1)
    for j = 1:size(M,2)
        M_for(i,j) = M_for(i,j) * 5;
    end
end
tempo_for = toc;
fprintf('Tempo usando FOR: %.6f segundos\n', tempo_for);

% Metodo 2: operacao vetorizada M*5 (ou 5*M)
tic;
M_vet = M*5;
tempo_vet = toc;
fprintf('Tempo usando M*5 (vetorizado): %.6f segundos\n', tempo_vet);

fprintf('A operacao vetorizada foi aproximadamente %.1f vezes mais rapida.\n', ...
    tempo_for/tempo_vet);

% Comentario (a incluir no relatorio):
% - O laco FOR percorre elemento por elemento (1500*1500 = 2.250.000
%   iteracoes), o que e MUITO mais lento no MatLab/Octave.
% - A operacao vetorizada M*5 usa rotinas internas otimizadas (BLAS/SIMD)
%   e e ordens de grandeza mais rapida.
% - Conclusao: sempre que possivel, evitar lacos explicitos e usar
%   operacoes vetoriais/matriciais no MatLab.


%% 3.5 - Matriz X 2x3, media por linha e subtracao
X = [4 8 6 ; 2 5 9];   % matriz 2x3 escolhida livremente
disp('Matriz X:'); disp(X);

M_media = mean(X,2);           % media de cada linha (vetor coluna 2x1)
disp('M = mean(X,2):'); disp(M_media);

X1 = X - M_media*ones(1,3);
disp('X1 = X - M*ones(1,3):'); disp(X1);

%% 3.6 - Comparacao entre X e X1
fprintf('Media de cada linha de X:\n'); disp(mean(X,2));
fprintf('Media de cada linha de X1 (deve ser ~0):\n'); disp(mean(X1,2));

% Comentario (a incluir no relatorio):
% - mean(X,2) calcula a media de cada LINHA de X.
% - M*ones(1,3) replica essa media ao longo das 3 colunas, formando uma
%   matriz do mesmo tamanho de X.
% - X1 = X - M*ones(1,3) subtrai a media de cada linha dos seus proprios
%   elementos, ou seja, X1 e X "centralizada" (media zero por linha).
% - Verificando mean(X1,2), o resultado e (aproximadamente) zero para
%   cada linha, confirmando que os dados foram centralizados.


%% ========================================================================
%  4 - OPERACOES COM ARQUIVOS DE AUDIO
% ========================================================================

arquivo_audio = fullfile(pasta_arquivos, 'musica.wav');

if exist(arquivo_audio, 'file')
    %% 4.1 - Leitura, reproducao e visualizacao do audio
    [Y, FS] = audioread(arquivo_audio);
    BITS = 16;  % valor tipico; audioread ja normaliza para [-1,1]

    soundsc(Y, FS);
    pause(length(Y)/FS + 0.5); % aguarda o audio terminar antes de continuar

    figure;
    plot(Y);
    title('4.1 - Amostras do sinal de audio (musica.wav)');
    xlabel('Amostra (n)'); ylabel('Amplitude');

    fprintf('Audio lido: Fs = %d Hz, %d amostras, %d canal(is)\n', ...
        FS, size(Y,1), size(Y,2));

    % Exemplo de escrita de audio (audiowrite)
    audiowrite(fullfile(pasta_arquivos, 'musica_copia.wav'), Y, FS);

    % Comentario (a incluir no relatorio):
    % - audioread(arquivo) le um arquivo de audio (wav, mp3, etc.) e
    %   retorna a matriz de amostras Y (normalizada entre -1 e 1) e a
    %   frequencia de amostragem FS. Se o arquivo for estereo, Y tera
    %   duas colunas (uma por canal).
    % - audiowrite(arquivo, Y, FS) grava a matriz de amostras Y em um
    %   novo arquivo de audio, usando a frequencia de amostragem FS.
    % - soundsc(Y,FS) reproduz o sinal nos alto-falantes, normalizando
    %   automaticamente a amplitude para evitar distorcao/saturacao.

    %% 4.2 - Alterando FS e BITS, tocando novamente e comparando
    FS_alterado = FS/2;     % reduz a frequencia de amostragem pela metade
    fprintf('Tocando com FS original (%d Hz)...\n', FS);
    soundsc(Y, FS);
    pause(length(Y)/FS + 0.5);

    fprintf('Tocando com FS alterado (%d Hz)...\n', FS_alterado);
    soundsc(Y, FS_alterado);
    pause(length(Y)/FS_alterado + 0.5);

    % Comentario (a incluir no relatorio):
    % - Ao reduzir FS (por exemplo, pela metade) sem alterar as amostras,
    %   o audio e reproduzido mais LENTO e em um TOM MAIS GRAVE, pois o
    %   MatLab/Octave interpreta as mesmas amostras como se tivessem sido
    %   capturadas a uma taxa menor, "esticando" o sinal no tempo.
    % - O parametro BITS afeta a resolucao/quantizacao com que o som e
    %   reproduzido; reduzir a quantidade de bits diminui a qualidade
    %   (aumenta o ruido de quantizacao), tornando o audio mais "granulado".
else
    warning(['Arquivo de audio nao encontrado: ' arquivo_audio ...
        '. Verifique se ele esta na pasta Arquivos_Trabalho1.']);
end


%% ========================================================================
%  5 - OPERACOES COM ARQUIVOS DE IMAGEM
% ========================================================================

arquivo_imagem = fullfile(pasta_arquivos, 'teste.bmp');

if exist(arquivo_imagem, 'file')
    %% 5.1 e 5.2 - Leitura e visualizacao da imagem
    [m, mapa] = imread(arquivo_imagem);

    if ~isempty(mapa)
        % Imagem indexada: converte para escala de cinza usando o mapa
        Y = ind2gray(m, mapa);
    else
        % Imagem ja em escala de cinza (ou RGB): normaliza para [0,1]
        if size(m,3) == 3
            Y = rgb2gray(m);
        else
            Y = m;
        end
        Y = im2double(Y);
    end

    figure;
    imshow(Y);
    title('5.2 - Imagem teste.bmp (escala de cinza)');

    %% 5.3 - Funcao de binarizacao (ver funcao "binariza" no final do arquivo)
    limiar = 0.5;
    Y_binarizada_func = binariza(Y, limiar);

    figure;
    imshow(Y_binarizada_func);
    title('5.3 - Imagem binarizada pela funcao binariza()');

    %% 5.4 - Binarizacao direta com operador relacional
    Y1 = Y > 0.5;
    figure;
    imshow(Y1);
    title('5.4 - Imagem binarizada (Y > 0.5)');

    % Comentario (a incluir no relatorio):
    % - A funcao binariza(a,b) percorre a matriz "a" e atribui 0 aos
    %   pixels com intensidade menor que o limiar "b", e 1 aos demais.
    % - Y1 = Y > 0.5 faz exatamente a mesma coisa de forma vetorizada:
    %   o operador relacional gera uma matriz logica (0/1) diretamente.
    % - Os resultados de Y_binarizada_func e Y1 devem ser identicos
    %   (ambos separam a imagem em preto/branco a partir do limiar 0.5).
else
    warning(['Arquivo de imagem nao encontrado: ' arquivo_imagem ...
        '. Verifique se ele esta na pasta Arquivos_Trabalho1.']);
end

%% 5.5 - Leitura de teste1.bmp e visualizacao com mesh() e contour()
arquivo_imagem2 = fullfile(pasta_arquivos, 'teste1.bmp');

if exist(arquivo_imagem2, 'file')
    [m2, mapa2] = imread(arquivo_imagem2);

    if ~isempty(mapa2)
        Y2 = ind2gray(m2, mapa2);
    else
        if size(m2,3) == 3
            Y2 = rgb2gray(m2);
        else
            Y2 = m2;
        end
        Y2 = im2double(Y2);
    end

    figure;
    mesh(double(Y2));
    title('5.5 - Visualizacao 3D de teste1.bmp (mesh)');
    xlabel('Coluna'); ylabel('Linha'); zlabel('Intensidade');

    figure;
    contour(double(Y2));
    title('5.5 - Curvas de nivel de teste1.bmp (contour)');
    xlabel('Coluna'); ylabel('Linha');

    % Comentario (a incluir no relatorio):
    % - mesh() exibe a imagem como uma superficie 3D, onde a altura (eixo
    %   z) representa a intensidade do pixel em cada posicao (linha,coluna).
    %   Isso permite visualizar "relevos" de brilho na imagem.
    % - contour() exibe curvas de nivel (linhas que unem pixels de mesma
    %   intensidade), similar a um mapa topografico, permitindo identificar
    %   regioes de intensidade semelhante e bordas/transicoes na imagem.
else
    warning(['Arquivo de imagem nao encontrado: ' arquivo_imagem2 ...
        '. Verifique se ele esta na pasta Arquivos_Trabalho1.']);
end


%% ========================================================================
%  6 - ATIVIDADES
% ========================================================================

%% 6.1 - Comentario sobre linspace(x1,x2,N)
% x = linspace(x1, x2, N) gera um vetor com N pontos igualmente
% espacados, comecando em x1 e terminando em x2 (incluindo ambos os
% extremos). O espacamento entre pontos consecutivos e (x2-x1)/(N-1).
% Se N for omitido, o padrao e N = 100.
x1_teste = 0; x2_teste = 10; N_teste = 5;
exemplo_linspace = linspace(x1_teste, x2_teste, N_teste);
disp('Exemplo de linspace(0,10,5):'); disp(exemplo_linspace);

%% 6.2.i - y[n] = n*sen(n*pi/2), 0 <= n <= 10, usando operacao vetorial
n6 = 0:10;
y6 = n6 .* sin(n6*pi/2);

figure;
stem(n6, y6);
title('6.2.i - y[n] = n*sen(n\pi/2)');
xlabel('n'); ylabel('y[n]');
grid;

%% 6.2.ii - z[n] = 0,5^n * e^{j n pi/2}, 0 <= n <= 10
n6b = 0:10;
z6 = (0.5.^n6b) .* exp(1j*n6b*pi/2);

figure;
subplot(2,1,1);
stem(n6b, real(z6));
title('6.2.ii - Parte real de z[n]');
xlabel('n'); ylabel('Re\{z[n]\}');
grid;

subplot(2,1,2);
stem(n6b, imag(z6));
title('6.2.ii - Parte imaginaria de z[n]');
xlabel('n'); ylabel('Im\{z[n]\}');
grid;

figure;
stem(n6b, abs(z6));
title('6.2.ii - Modulo de z[n] (|z[n]| = 0.5^n)');
xlabel('n'); ylabel('|z[n]|');
grid;

% Comentario (a incluir no relatorio):
% - z[n] e um sinal complexo cujo modulo decai exponencialmente (0.5^n)
%   e cuja fase gira 90 graus a cada amostra (devido ao termo
%   exp(j*n*pi/2)), caracterizando uma senoide complexa amortecida.


%% ========================================================================
%  FUNCAO LOCAL: binariza
% ========================================================================
function x = binariza(a,b)
    % binariza  Binariza uma imagem em escala de cinza.
    %   x = binariza(a,b) retorna uma matriz binaria (0 ou 1), onde os
    %   pixels de "a" menores que o limiar "b" recebem 0 (preto), e os
    %   demais recebem 1 (branco).
    %
    %   a - matriz com a imagem a ser binarizada
    %   b - limiar de binarizacao (intensidade do pixel)

    x = zeros(size(a));
    x(a >= b) = 1;
end
