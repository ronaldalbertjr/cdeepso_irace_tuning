%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Leonel Carvalho, PhD (email: leonel.m.carvalho@inescporto.pt)
% Carolina Marcelino, PhD (email: carolimarc@cos.ufrj.br)
% April 02, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright (c) 2018, Leonel Carvalho and Carolina Marcelino
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without
%modification, are permitted provided that the following conditions are
%met:
%
%    * Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in
%      the documentation and/or other materials provided with the 
%      distribution
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%POSSIBILITY OF SUCH DAMAGE.

%CITE "Solving security constrained optimal power flow problems: a hybrid
%evolutionary approach". Applied Intelligence, Springer, pp.: 1-19. 2018
%and
%"Applying C-DEEPSO to solve Large Scale Global Optimization Problems"
%Proc. IEEE on Congress on Evolutionary Computation (CEC), 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
global ff_par;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Basic functions
% 1 - Rosenbrock
% 2 - Griewank
% 3 - Rastrigin
%Function Definition
ff_par.ff = 1;
% Dimension of optimization problem
ff_par.D = 100;
ff_par.Xmin = -100;
ff_par.Xmax = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE random number generator
seed = 1234;
rng( seed, 'twister'  );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET STRATEGIC PARAMETERS 
%Population size
popSize = 100;
%memory size 
memGBestSize = 5;
%strategyCDEEPSO 
% 1 -> Sg ; % 2 -> Pb ; % 3 -> Sg-rnd ; % 4 -> Pb-rnd; % 5 -> SgPb-rnd
strategyCDEEPSO = 5; 
% DE Strategy 
typeCDEEPSO = 3; % 2 -> Rand/1/bin; % 3 -> Best/1/bin
%Mutatoin rate 
mutationRate = 0.5;
%Communication rate 
communicationProbability = 0.9;
%fitness evaluate 
maxFitEval = 100000;
%generations
maxGen =50000;
maxGenWoChangeBest = 1000;
%% SET SIMULATION PARAMETERS
printConvergenceResults = 100; 
printConvergenceChart = 1; % 1 -> Chart ; 0 -> No Chart ;
%Maximun run 
maxRun = 30;
memBestFitness = zeros( 1, maxRun );
memBestSolution = zeros( maxRun, ff_par.D );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Matrix results
resultsCDEEPSO = zeros( maxRun, maxFitEval );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PRINT message
    fprintf('           C-DEEPSO 2018             \n');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PRINT simulation parameters
    fprintf('\nMax Gen: %d\n', maxGen);
    fprintf('Max Fit Evaluations: %d\n', maxFitEval);
    fprintf('Max Gen With Equal Global Best: %d\n',maxGenWoChangeBest);
    fprintf('Population Size: %d\n', popSize);
    fprintf('Memory Size: %d\n', memGBestSize);
    fprintf('Mutation Rate: %.3f\n', mutationRate);
    fprintf('Communication Probability: %.3f\n\n', communicationProbability);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1 : maxRun
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RUN CDEEPSO 
        fprintf('************* Run %d *************\n', i);
        ff_par.fitEval = 0;
        ff_par.bestFitEval = 0;
        ff_par.memNumFitEval = zeros( 1, maxFitEval );
        ff_par.memFitEval = zeros( 1, maxFitEval );
        [ gbestfit, gbest ] = CDEEPSO( popSize, memGBestSize, strategyCDEEPSO, typeCDEEPSO, mutationRate, communicationProbability, maxGen, maxFitEval, ...
            maxGenWoChangeBest, printConvergenceResults, printConvergenceChart );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ff_par.memNumFitEval = ff_par.memNumFitEval( 1:maxFitEval );
        ff_par.memFitEval = ff_par.memFitEval( 1:maxFitEval );
        memBestFitness( i ) = gbestfit;
        memBestSolution( i, : ) = gbest;
        resultsCDEEPSO( i, : ) = ff_par.memFitEval;
    end
if maxRun ==  1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PRINT final results
    fprintf('Best Solution:\n');
    for i = 1 : ff_par.D
        fprintf('x[%d]: %.4e\n', i, gbest( i ) );
    end
    fprintf('Best Fitness: %.8e\n', min( memBestFitness ) );
    fprintf('Worst Fitness: %.8e\n', max( memBestFitness ) );
    fprintf('Median: %.8e\n', median( memBestFitness ) );
    fprintf('Average Best Fitness: %.8e\n', mean( memBestFitness ) );
    fprintf('Standard Desviation Best Fitness: %.8e\n', std( memBestFitness ) );
    vetor = [min( memBestFitness ), max( memBestFitness ), median( memBestFitness ), mean( memBestFitness ), std( memBestFitness )];
    % PRINT convergence chart
    ff_par.memNumFitEval = ff_par.memNumFitEval( 1:maxFitEval );
    ff_par.memFitEval = ff_par.memFitEval( 1:maxFitEval );
    plot( ff_par.memNumFitEval, ff_par.memFitEval );
    xlabel('evaluation');
    ylabel('fitness');
    grid on;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PRINT final results
    fprintf('Best Fitness: %.8e\n', min( memBestFitness ) );
    fprintf('Worst Fitness: %.8e\n', max( memBestFitness ) );
    fprintf('Median: %.8e\n', median( memBestFitness ) );
    fprintf('Average Best Fitness: %.8e\n', mean( memBestFitness ) );
    fprintf('Standard Desviation Best Fitness: %.8e\n', std( memBestFitness ) );
    vetor = [min( memBestFitness ), max( memBestFitness ), median( memBestFitness ), mean( memBestFitness ), std( memBestFitness )];
    memBestFitness(:);
    avgFitEval = zeros(1, maxFitEval );
    for i = 1 : maxFitEval
        avgFitEval( 1, i ) = mean( resultsCDEEPSO( :, i ) );        
    end
    figure(2);
    xlabel('evaluation');
    ylabel('mean fitness');
    grid on;
    plot( ff_par.memNumFitEval, avgFitEval );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end