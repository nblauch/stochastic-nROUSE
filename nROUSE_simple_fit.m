function nROUSE_simple_fit

    Ndata=160;

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


    VisOrth=[0,0;  % from VPR
             1,0;  % from VTR
             0,0;  % from VMK
             1,0;  % from VTRC
             0,1]; % from VFLC
         
    OrthSem=eye(2); % identity matrix for weights
    SemOrth=eye(2); % same identity matrix for feedback
    
% experimental procedures

    ChoiceDur=500;
    durations=[50,400];
% parameters

    F=.25;          % semantic to orthographic feedback scalar
    N=0.0302;    % noise constant
    L=.15;          % constant leak current
    D=[.324 .324 .324];         % synaptic depletion rate
    R=[.022 .022 .022];         % recovery rate
    Idefault=[0.9844 0.9844 0.9844];       % inhibition constant
    I=Idefault;
    T=.15;          % activation threshold
    S=[0.0294,0.0609,.015];    % integration time constants at each level
    Reps=[1 1 1];
    Attention=1;
    targ_lat=zeros(2,2);
    foil_lat=zeros(2,2);
    Nparms=3;
    
    function err=fit_rouse(parms)

       % Reps(1)=parms(1);
        Attention=parms(1);
        I=parms(2).*Idefault;
        N=parms(3);
       
        for cd=1:2      % cd is a step through index for conditions    
            if cd==1         % target primed
                VisOrth(VPR,:)=[2,0];              % set to 2 because there are two visual copies on the screen
            elseif cd==2      % foil primed
                VisOrth(VPR,:)=[0,2];
            end

            [accs(:,cd), Latency]=simulate;  % run all prime durations and return accuracy and latency
            targ_lat(:,cd)=Latency(:,TARG);
            foil_lat(:,cd)=Latency(:,FOIL);

        end
        accs(accs==0)=1/(2*Ndata);
        accs(accs==1)=1-(1/(2*Ndata));
        
        err=2*Ndata*sum(sum(obs.*log(obs./accs)));
        err=err+2*Ndata*sum(sum((1-obs).*log((1-obs)./(1-accs))));

    end
    
    data=csvread('subjects.csv');
    
    results=zeros(25,12);
    
    neural=csvread('fit_subjects_attention.csv');
    figure
    for s=1:5        
        TarDur=round(data(s,1));
        MaskDur=500-TarDur;
        obs=[data(s,2) data(s,4);data(s,3) data(s,5)];
    
%         Nparms=1;
%         [BestN err1]=fminsearch(@fit_rouse,.0302)
%         Nparms=2;
%         [parms err2]=fminsearch(@fit_rouse,[BestN .9844])
        
        %%%% fit with just N
        
        %%%% then fit with Inhibition and N
        
        
       % [parms err1]=fminsearch(@fit_rouse,[1 1 .03]);
        
        
     %   [best_parms1 err1]=fminsearch(@fit_rouse,parms);
     %   parms=([.3 .8 .026]);  % good for #2
     %   [best_parms2 err2]=fminsearch(@fit_rouse,parms);
%         if err1<err2
%             parms=best_parms1;
%         else
%             parms=best_parms2;
%         end
%        [parms err]=fminsearch(@fit_rouse,parms)
     
        parms=neural(s,[10:12]);
        err=fit_rouse(parms);
        
        results(s,:)=[1./targ_lat(:,TARG)' 1./targ_lat(:,FOIL)' 1./foil_lat(:,FOIL)' 1./foil_lat(:,TARG)' err parms];
              
        subplot(3,2,s);
        hold on
        plot(durations,accs(:,1));
        plot(durations,accs(:,2));
        plot(durations,obs(:,1),'--');
        plot(durations,obs(:,2),'--');        
        legend('Pred. targ prime','Pred. foil prime', 'Obs. targ prime', 'Obs. foil prime');
        xlabel('Prime duration (ms)');
        ylabel('Proportion correct');
        hold off
        
%         subplot(3,1,2);
%         plot(durations,[targ_lat(:,TARG) foil_lat(:,TARG)]);
%         legend('Target','Foil');
%         xlabel('Prime duration (ms)');
%         ylabel('Latency (ms)');
%         title('Target prime');
%         subplot(3,1,3);
%         plot(durations,[targ_lat(:,FOIL) foil_lat(:,FOIL)]);
%         legend('Target','Foil');
%         xlabel('Prime duration (ms)');
%         ylabel('Latency (ms)');
%         title('Foil prime');
  
    end
    
    csvwrite('no_attention.csv',results);
    


    
    function [acc, Latency]=simulate
        
        Latency=zeros(size(durations,2),2);     % identification latencies for each choice
        for pd=1:size(durations,2)      % pd is a step through index for prime durations
            
            PrimeDur=durations(pd);
            SOA=PrimeDur+TarDur+MaskDur;        % time when choices are presented
            
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


            for t=1:PrimeDur+TarDur+MaskDur+ChoiceDur
                
                % udpate visual layer
                if t==1                         % present prime
                    inp_vis=zeros(1,5);
                    inp_vis(VPR)=1;
                elseif t==PrimeDur+1           % present target
                    inp_vis=zeros(1,5);
                    inp_vis(VTR)=Attention;
                elseif t==PrimeDur+TarDur+1    % present mask
                    inp_vis=zeros(1,5);
                    inp_vis(VMK)=1;
                elseif t==SOA+1                 % present choices
                    inp_vis=zeros(1,5);
                    inp_vis(VTRC)=1;
                    inp_vis(VFLC)=1;                
                end
                [new_mem_vis,new_amp_vis,out_vis]=update(mem_vis,amp_vis,inp_vis,1);
                
                % update orthographic layer
                inp_orth=out_vis*VisOrth;
                inp_orth=inp_orth+F.*out_sem*SemOrth;
                [new_mem_orth,new_amp_orth,out_orth]=update(mem_orth,amp_orth,inp_orth,2);

                % update semantic layer
                inp_sem=out_orth*OrthSem;
                [new_mem_sem,new_amp_sem,out_sem]=update(mem_sem,amp_sem,inp_sem,3);       

                % perceptual decision process
                if t>SOA+50    % the +50 gives things a chance to get going before peak activation is checked
                    for tf=1:2  % step through index for target and foil
                        if out_sem(tf)<old_sem(tf) && Latency(pd,tf)==0    % check for peak activation
                            Latency(pd,tf)=t-SOA;
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
            var_diff=sum(exp(N.*Latency(pd,:)));         % variance of difference between target and foil latency
            
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

        old_out=subplus(old_mem-T).*old_amp.*Reps(level);    % output is above threshold activation times available synaptic resources

        if level==1     % visual inhibition                 
            inhibit([1:3])=sum(old_out([1:3]));  % prime, target, and mask mutually inhibit each other (centrally presented)
            inhibit([4:5])=old_out([4:5]);      % choice words only self inhibit (unique screen location)
        else
            inhibit=sum(old_out);               % for orthography and semantics, everything inhibits everything
        end
                    % update membrane potential and synaptic resources
                    
        new_mem=old_mem + (S(level) .*  (  ( inp .* (1 - old_mem) )  -  (L.*old_mem)  -  (I(level).*inhibit.*old_mem)  ));
        new_amp=old_amp + (S(level) .*  (  (  R(level)  .* (1 - old_amp) )  -  (D(level).*old_out))  );

        new_mem(new_mem<0)=0;       % keep things within bounds
        new_mem(new_mem>1)=1;
        new_amp(new_amp<0)=0;
        new_amp(new_amp>1)=1;
    end
end
