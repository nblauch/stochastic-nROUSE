function o = nROUSE_simple_5node(oInput)

% assignments for visual layer

    VPR=1;   % visual prime
    VTR=2;   % visual target
    VMK=3;   % visual mask
    VTRC=4;  % visual target choice
    VFLC=5;  % visual foil choice

% assignments for orthographic and semantic layers

    TARG=1;  % target
    FOIL=2;  % foil
    
% weight matrices

    o.VisOrth=[0,0;  % from VPR
             1,0;  % from VTR
             0,0;  % from VMK
             1,0;  % from VTRC
             0,1]; % from VFLC
         
    o.OrthSem=eye(2); % identity matrix for weights
    o.SemOrth=eye(2); % same identity matrix for feedback
    
% experimental procedures

    o.TarDur=50;
    o.MaskDur=500-o.TarDur;
    o.ChoiceDur=500;
    o.durations=[17,50,150,400,2000];
% parameters

    o.F=.25;          % semantic to orthographic feedback scalar
    o.N=0.0302;    % noise constant
    o.L=.15;          % constant leak current
    o.D=.324;         % synaptic depletion rate
    o.R=.022;         % recovery rate
    o.I=0.9844;       % inhibition constant
    o.T=.15;          % activation threshold
    o.S=[0.0294,0.0609,.015];    % integration time constants at each level
    
    o.stochasticPrime = 0;
    o.stochasticTarget = 0;
    o.stochasticMask = 0;
    o.stochasticChoices = 0;
    o.stochasticVisualInput = 0;
    o.stochasticVisOrth = 0;
    o.visualInputSD = 0;
    o.newItemDifferences = 0;
    
    % All fields in the user-supplied "oIn" overwrite corresponding fields in "o".
    fields=fieldnames(oInput);
    for i=1:length(fields)
        field=fields{i};
        o.(field)=oInput.(field);
    end
    
    for cd=1:2      % cd is a step through index for conditions    
        if cd==1         % target primed
            o.VisOrth(VPR,:)=[2,0];              % set to 2 because there are two visual copies on the screen
            if o.stochasticVisOrth
                o.visOrth(VPR,:)=[2*o.targetConnectionWeight,0];
            end
        elseif cd==2      % foil primed
            o.VisOrth(VPR,:)=[0,2];
            if o.stochasticVisOrth
                o.visOrth(VPR,:)=[2*o.foilConnectionWeight,0];
            end
        end

        [o.accs(:,cd), o.Latency]=simulate;  % run all prime o.durations and return accuracy and latency
        o.targ_lat(:,cd)=o.Latency(:,TARG);
        o.foil_lat(:,cd)=o.Latency(:,FOIL);
    end
%     
%     subplot(3,1,1);
%     accs
%     plot(o.durations,o.accs);
%     xscale('log');
%     xlabel('durations(ms)');
%     ylabel('Accuracy');
%     legend('target prime','foil prime');
%     subplot(3,1,2);
%     targ_lat
%     plot(o.durations,o.targ_lat);
%     xscale('log');
%     xlabel('o.durations(ms)');
%     ylabel('Target latency (ms)');
%     legend('target prime','foil prime');
%     subplot(3,1,3);
%     foil_lat
%     plot(o.durations,o.foil_lat);
%     xscale('log');
%     xlabel('durations(ms)');
%     ylabel('Foil latency (ms)');
%     legend('target prime','foil prime');

    
    function [acc, Latency]=simulate
        
        Latency=zeros(size(o.durations,2),2);     % identification latencies for each choice
        for pd=1:size(o.durations,2)      % pd is a step through index for prime o.durations
            
            o.PrimeDur=o.durations(pd);
            o.SOA=o.PrimeDur+o.TarDur+o.MaskDur;        % time when choices are presented
            
            mem_vis=zeros(1,5);     % initialize neural variables
            amp_vis=ones(1,5);
            out_vis=zeros(1,5);
            mem_orth=zeros(1,2);
            amp_orth=ones(1,2);
            out_orth=zeros(1,2);
            mem_sem=zeros(1,2);
            amp_sem=ones(1,2);
            out_sem=zeros(1,2);
            old_sem=zeros(1,2);     % needed to check for peak output


            for t=1:o.PrimeDur+o.TarDur+o.MaskDur+o.ChoiceDur
                
                % udpate visual layer
                if t==1                         % present prime
                    inp_vis=zeros(1,5);
                    inp_vis(VPR)=1;
                    if o.stochasticVisualInput && o.stochasticPrime
                        inp_vis(VPR) = normrnd(1,o.visualInputSD);
                    end
%                     if o.newItemDifferences
%                         if cd ==1
%                             inp_vis(VPR) = o.targetConnectionWeight;
%                         end
%                         if cd==2
%                             inp_vis(VPR) = o.foilConnectionWeight;   
%                         end
%                     end
                elseif t==o.PrimeDur+1           % present target
                    inp_vis=zeros(1,5);
                    inp_vis(VTR)=1;
                    if o.stochasticVisualInput && o.stochasticTarget
                        inp_vis(VTR) = normrnd(1,o.visualInputSD);
                    end
                    if o.newItemDifferences
                        inp_vis(VTRC) = o.targetConnectionWeight;
                    end
                elseif t==o.PrimeDur+o.TarDur+1    % present mask
                    inp_vis=zeros(1,5);
                    inp_vis(VMK)=1;
                    if o.stochasticVisualInput && o.stochasticMask
                        inp_vis(VMK) = normrnd(1,o.visualInputSD);
                    end
                elseif t==o.SOA+1                 % present choices
                    inp_vis=zeros(1,5);
                    inp_vis(VTRC)=1;
                    inp_vis(VFLC)=1;
                    if o.stochasticVisualInput && o.stochasticChoices
                        inp_vis(VTRC) = normrnd(1,o.visualInputSD);
                        inp_vis(VFLC) = normrnd(1,o.visualInputSD);
                    end
%                     if o.newItemDifferences
%                         inp_vis(VTRC) = o.targetConnectionWeight;
%                         inp_vis(VFLC) = o.foilConnectionWeight;
%                     end

                end
                [new_mem_vis,new_amp_vis,out_vis]=update(mem_vis,amp_vis,inp_vis,1);
                
                % update orthographic layer
                inp_orth=out_vis*o.VisOrth;
                inp_orth=inp_orth +o.F.*out_sem*o.SemOrth;
                [new_mem_orth,new_amp_orth,out_orth]=update(mem_orth,amp_orth,inp_orth,2);

                % update semantic layer
                inp_sem=out_orth*o.OrthSem;
                [new_mem_sem,new_amp_sem,out_sem]=update(mem_sem,amp_sem,inp_sem,3);       

                % perceptual decision process
                if t>o.SOA+50    % the +50 gives things a chance to get going before peak activation is checked
                    for tf=1:2  % step through index for target and foil
                        if out_sem(tf)<old_sem(tf) && Latency(pd,tf)==0    % check for peak activation
                            Latency(pd,tf)=t-o.SOA;
                        end
                    end
                    old_sem=out_sem;
                end
                
                % swap new variables for old variables
                
                mem_vis=new_mem_vis;
                amp_vis=new_amp_vis;
                mem_orth=new_mem_orth;
                amp_orth=new_amp_orth;
                mem_sem=new_mem_sem;
                amp_sem=new_amp_sem;

            end
            
            % calculate accuracy
            mean_diff=Latency(pd,FOIL)-Latency(pd,TARG); % average difference between target and foil latency
            var_diff=sum(exp(o.N.*Latency(pd,:)));         % variance of difference between target and foil latency
            
            acc(pd,1)=1-normcdf(0,mean_diff,var_diff.^.5);
            
            if Latency(pd,TARG)==0 && Latency(pd,FOIL)>0      % target never launched
                acc(pd,1)=0;
            elseif Latency(pd,TARG)>0 && Latency(pd,FOIL)==0  % foil never launched
                acc(pd,1)=1;
            elseif Latency(pd,TARG)==0 && Latency(pd,FOIL)==0 % neither launched
                acc(pd,1)=.5;
            end
        end
    end


    function [new_mem,new_amp,old_out]=update(old_mem,old_amp,inp,level)

        old_out=subplus(old_mem-o.T).*old_amp;    % output is above threshold activation times available synaptic resources

        if level==1     % visual inhibition                 
            inhibit([1:3])=sum(old_out([1:3]));  % prime, target, and mask mutually inhibit each other (centrally presented)
            inhibit([4:5])=old_out([4:5]);      % choice words only self inhibit (unique screen location)
        else
            inhibit=sum(old_out);               % for orthography and semantics, everything inhibits everything
        end
                    % update membrane potential and synaptic resources
                    
        new_mem=old_mem + (o.S(level) .*  (  ( inp .* (1 - old_mem) )  -  (o.L.*old_mem)  -  (o.I.*inhibit.*old_mem)  ));
        new_amp=old_amp + (o.S(level) .*  (  (  o.R  .* (1 - old_amp) )  -  (o.D.*old_out))  );

        new_mem(new_mem<0)=0;       % keep things within bounds
        new_mem(new_mem>1)=1;
        new_amp(new_amp<0)=0;
        new_amp(new_amp>1)=1;
    end
end