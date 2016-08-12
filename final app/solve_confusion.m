function [predicted_label] = solve_confusion(filename)

    if exist('confusion_solver.mat','file') == 0
        [a, b, label] = cluster_pole_zero();
        trainer = [a b];

         bestcv = 0;
         bestc = 0;
         bestg = 0;


         for log2c = -1.1:3.1
             for log2g = -4.1:1.1
                 cmd = ['-t 0 -v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g),' -q' ];
                 cv = svmtrain(label,trainer, cmd);

                 if cv >= bestcv
                     bestcv = cv;
                     bestc = 2^log2c;
                     bestg = 2^log2g;
                 end
             end
         end

        cmd = ['-t 0 -c ',num2str(bestc), ' -g ',num2str(bestg),' -q'];

        confusion_predictor = svmtrain(label,trainer);

        save('confusion_solver','confusion_predictor');
    else
        load('confusion_solver');
    end
    
    feature = practice_zeros(fileno);
    
    l = size(feature);
    [predicted_label, ~, ~] = svmpredict(zeros(l(1),1), ...
                                                    feature, confusion_predictor);

end