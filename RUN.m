function best_fitness=RUN(mutationRate,communicationProbability,strategyCDEEPSO)
    close all;
    global ff_par;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Basic functions
    % 1 - Rosenbrock
    % 2 - Griewank
    % 3 - Rastrigin
    %Function Definition
    ff_par.ff = 1;
    % Dimension of optimization problem
    ff_par.D = 30;
    ff_par.Xmin = -100;
    ff_par.Xmax = 100;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% SET STRATEGIC PARAMETERS
    %Population size
    popSize = 30;
    %memory size
    memGBestSize = 5;
    %strategyCDEEPSO
    % 1 -> Sg ; % 2 -> Pb ; % 3 -> Sg-rnd ; % 4 -> Pb-rnd; % 5 -> SgPb-rnd
    %strategyCDEEPSO = 5;
    % DE Strategy
    typeCDEEPSO = 3; % 2 -> Rand/1/bin; % 3 -> Best/1/bin
    %Mutatoin rate and Communication rate
    %fitness evaluate
    maxFitEval = 100000;
    %generations
    maxGen =50000;
    
    maxGenWoChangeBest = 1000; %Para rodar normal
    
    printConvergenceResults = 100; 
    printConvergenceChart = 0; % 1 -> Chart ; 0 -> No Chart ;
    
    %Maximun run
    maxRun = 1;
    memBestFitness = zeros( 1, maxRun );
    memBestSolution = zeros( maxRun, ff_par.D );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Matrix results
    resultsCDEEPSO = zeros( maxRun, maxFitEval );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1 : maxRun
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RUN CDEEPSO 
        ff_par.fitEval = 0;
        ff_par.bestFitEval = 0;
        ff_par.memNumFitEval = zeros( 1, maxFitEval );
        ff_par.memFitEval = zeros( 1, maxFitEval );
        [ gbestfit, gbest, zero_gen ] = CDEEPSO( popSize, memGBestSize, strategyCDEEPSO, typeCDEEPSO, mutationRate, communicationProbability, maxGen, maxFitEval, ...
            maxGenWoChangeBest, printConvergenceResults, printConvergenceChart );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ff_par.memNumFitEval = ff_par.memNumFitEval( 1:maxFitEval );
        ff_par.memFitEval = ff_par.memFitEval( 1:maxFitEval );
        memBestFitness( i ) = gbestfit;
        memBestSolution( i, : ) = gbest;
        resultsCDEEPSO( i, : ) = ff_par.memFitEval;
    end
    %best_fitness = min( memBestFitness );
    fprintf('Result for irace=%g\n', zero_gen);
    %exit;
end
%% PRINT final results
%fprintf('Best Solution:\n');
%for i = 1 : ff_par.D
%    fprintf('x[%d]: %.4e\n', i, gbest( i ) );
%end
%fprintf('Best Fitness: %.8e\n', min( memBestFitness ) );
%fprintf('Worst Fitness: %.8e\n', max( memBestFitness ) );
%fprintf('Median: %.8e\n', median( memBestFitness ) );
%fprintf('Average Best Fitness: %.8e\n', mean( memBestFitness ) );
%fprintf('Standard Desviation Best Fitness: %.8e\n', std( memBestFitness ) );
%vetor = [min( memBestFitness ), max( memBestFitness ), median( memBestFitness ), mean( memBestFitness ), std( memBestFitness )];
