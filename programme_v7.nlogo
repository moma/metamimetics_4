;; variables globales
globals [
cooperation-rate 
satisfaction-rate
fraction-best
maxi
mini
conf
anti
life-distribution]

;; variables relatives aux tortues
turtles-own [
cooperate?       ;; patch will cooperate
rule                   ;; patch will have one of four rules: 1=Maxi 2=mini 3=conformist 4=anticonformist  
score                ;; score resulting from interaction of neighboring patches. It is dictated by the PD payoffs and the discount factor
last-score ;; score à t-1
inst-score ;; score à t
count-majority-rule ; nbr de tortues voisines ayant la règle majoritaire à t
count-minority-rule ; nbr de tortues voisines ayant la règle minoritaire à t 
last-count-majority-rule ; nbr de tortues voisines ayant la règle majoritaire à t-1 
last-count-minority-rule ; nbr de tortues voisines ayant la règle minoritaire à t-1
satisfaction ;; score de satisfaction
age   ;;
rule?   ;; tortue à une règle qu’elle veut changer ou non
behavior?  ;; tortue à un comportement qu’elle veut changerou non
move?   ;; tortue est à un endroit d’ou elle veut bouger ou non
theta_1 ;; prob de changer son comportement
theta_2 ;; prob de changer sa règle
prob-reflexion? ;;
weighting-history-maxi
weighting-history-mini
weighting-history-conf
weighting-history-anti ;; poids associé au score 
likelihood-to-move ;; prob de bouger
 ]


to setup
  clear-all  ;; monde vide
  ask patches [              ;; dit aux patches
     set pcolor 0    ;; d’avoir la couleur 0
      if random-float 1 < density [ sprout 1 ]  ;; s’il n’y a pas de tortue en créer une
              ]
  ask turtles [
      set rule (random 4) + 1 ;; donne une stratégie à chaque tortue
            set shape "face happy" ;; chaque tortue est contente au départ
         ifelse random-float 1.0 < (inicoop / 100)  ;; si la coopération initiale de la tortue est supérieure à un entier alors ont dit qu’il coopère sinon on dit qu’il ne coopère pas  
            [set cooperate? true]
            [set cooperate? false]
          set score 0.0 ;; score de zéro au départ
          set rule? false  
          set behavior? false  
          set move? false  
      ifelse random-init
      [
          set theta_1 random-float 1.0
          set theta_2 random-float 1.0
          set weighting-history-maxi random-float 1.0   
          set weighting-history-mini random-float 1.0  
          set weighting-history-conf random-float 1.0  
          set weighting-history-anti random-float 1.0  
          set likelihood-to-move random-float 1.0
       ]  ;; si décide que l’initiation est randomisée on randomise tous les paramètres
        
    [
        set theta_1 Initial-prob-update-behavior
        set theta_2 Initial-prob-update-rule
        set weighting-history-maxi Initial-weighting-history
        set weighting-history-mini Initial-weighting-history
        set weighting-history-conf Initial-weighting-history
        set weighting-history-anti Initial-weighting-history
        set likelihood-to-move Initial-like-to-move 
     ]      ;; sinon on pose donne des valeurs aux paramètres mais du coup c’est uniforme pour toutes les tortues. pb?
       
      ]
      ask turtles[ establish-color ]
      init-age-FR2011 ;; utilise la fonction init-age pour déterminer l’age des tortues
      set-life-distribution-FR2011 ;; utilise la fonction set-life-distribution pour déterminer l’espérance de vie des tortues
      set-outputs
      reset-ticks
end


to go
    ask turtles [interact] 
    ask turtles [analyse-neighbors] 
    decision-stage
    learning-stage 
    ask turtles [calculate-satisfaction]
    moving-stage
    
   set-outputs            
   update-plot    
   reset-decisions 
   replacement
   update-views
    
    ask turtles [
      ifelse am-i-the-best? or am-i-progressing?; or am-i-the-best-global?
     [set shape "face happy"] ;; si am-i-the-best = true ou am-i-progressing = true ou si am-i-the-best-global = true la tortue a une tête contente
     [set shape "face sad"] ;; si am-i-the-best = false la tortue a une tête pas contente
                ]  
  update-views
  tick
end

to interact  ;; calculates the agent's payoff for Prisioner's Dilema. Each agents plays only with its neighbors
  let total-cooperators count (turtles-on neighbors) with [cooperate?] ;; calcul nombre coopérateur dans les voisins de chaque tortue
  set inst-score 0 
  ifelse cooperate? 
    [set inst-score total-cooperators * ( 1 - strength-of-dilemma)]   ;; cooperator gets score of a multiple of neighbors who cooperated 
    [set inst-score total-cooperators + (count (turtles-on neighbors) - total-cooperators) * strength-of-dilemma ]  ;; non-cooperator get score of a multiple of the neighbors who haven’t cooperated
  set last-score score ;; on stocke le score de t-1 dans score 
  if rule = 1 ;; si règle maxi
      [
          set score inst-score * ( 1 - weighting-history-maxi) + last-score * weighting-history-maxi ;; on calcule le score à t en fonction du score à t-1
        ]
    if rule = 2 ;; si règle mini
      [
         set score inst-score * ( 1 - weighting-history-mini) + last-score * weighting-history-mini ;; on calcule le score à t en fonction du score à t-1
        ]
    if rule = 3 ;; si règle conf
      [
           set score inst-score * ( 1 - weighting-history-conf) + last-score * weighting-history-conf   ;; on calcule le score à t en fonction du score à t-1
        ]
    if rule = 4 ;; si règle anticonf
      [
          set score inst-score * ( 1 - weighting-history-anti) + last-score * weighting-history-anti   ;; on calcule le score à t en fonction du score à t-1
        ]
end


to analyse-neighbors

  
  let mylist [rule] of (turtle-set turtles-on neighbors self)
  set mylist modes mylist
  
  
  set last-count-majority-rule count-majority-rule 
  set count-majority-rule length mylist

  let mylist2 [rule] of (turtle-set turtles-on neighbors self)
  let mylist3 []
  let j 1
  while [empty? mylist3] [
  let i 1
  repeat 4 [
    if length filter [? = i] mylist2 = j  [set mylist3 lput i mylist3] 
    set i i + 1
    ]
  set j j + 1
  ] 
  set last-count-minority-rule count-minority-rule 
  set count-minority-rule length mylist3
 
end

  
  

to decision-stage
   ask turtles [ 
     ifelse random-float 1 < likelihood-to-move  
       [if not am-i-the-best? or not am-i-progressing? 
         [set move? true]]  ;; si inf à likelihood-to-move et que la tortue n’est pas la meilleure alors move = true
       [ ifelse random-float 1 < theta_2  ;; sinon  
         [if (not am-i-the-best? or not am-i-progressing?) and not is-my-rule-the-best? 
           [set rule? true]] ;; si inf à theta_2//prob de changer règle et que la tortue n’est pas la meilleure et que sa règle non plus n’est pas la meilleure alors la règle peut changer
         [if random-float 1 < theta_1 and (not am-i-the-best? or not am-i-progressing?) 
           [set behavior? true]];; sinon si inf à theta_1//prob de changer le comportement et que la tortue n’est pas la meilleure alors le comportement peut changer
       ]
               ]
   ask turtles [
     if move? and all? neighbors [any? turtles-here] ;; si on peut bouger et que tous les voisins sont des tortues 
         [set move? false ;; il n’y a pas de raison de bouger
           ifelse is-my-rule-the-best? or am-i-progressing? 
      [set behavior? true] ;; si la règle est la meilleure alors on peut changer comportement
      [set rule? true] ;; sinon on peut changer la règle
           ]
        ifelse not am-i-progressing? and (rule? or behavior?) and all? neighbors [not any? turtles-here] ;;  si on peut changer la règle ou le comportement et que parmi les voisins il y a des vides 
         [set move? true ;; on peut bouger la tortue
           set rule? false ;; il n’y a pas de raison de changer la règle
           set behavior? false ] ;; il n’y a pas de raison de changer le comportement
         [set move? true ;; on peut bouger la tortue
          set rule? true ;; il n’y a pas de raison de changer la règle
          set behavior? true ] ;; il n’y a pas de raison de changer le comportement
        if age < 12  ;; vérifier comment se passe l’apprentissage
        [set rule? false]
        ]
end



to learning-stage
    ask turtles [ 
       if rule?   ;; si on peut changer la règle
        [
            select-rule  
            select-behavior
      ]
       if behavior? ;; si on peut changer le comportement
      [select-behavior]
       ]
    
end



to calculate-satisfaction
    if rule = 1 ;; si règle maxi
      [
          let top [score] of max-one-of (turtle-set turtles-on neighbors self) [score]
          let bottom [score] of min-one-of (turtle-set turtles-on neighbors self) [score]
          ifelse (top - bottom) = 0
          [set satisfaction 0.5]
          [set satisfaction (score - bottom) / (top - bottom)] ;;sinon calcul de la satisfaction par rapport au score
        ]
    if rule = 2 ;; si règle mini
      [
          let top [-1 * score] of min-one-of (turtle-set turtles-on neighbors self) [score]
          let bottom [ -1 * score] of max-one-of (turtle-set turtles-on neighbors self) [score]
          ifelse (top - bottom) = 0
          [set satisfaction 0.5]
          [set satisfaction ((-1 * score) - bottom) / (top - bottom)] 
        ]
    if rule = 3 ;; si règle conf
      [
          let top-rule one-of majority-rules
          let top count (turtle-set turtles-on neighbors self) with [rule = top-rule]/ count (turtle-set turtles-on neighbors self) 
          let bottom-rule one-of minority-rules
          let bottom count (turtle-set turtles-on neighbors self) with [rule = bottom-rule]/ count     (turtle-set turtles-on neighbors self)     
          let my-rule rule
          let my-group count (turtle-set turtles-on neighbors self) with [rule = my-rule]/ count     (turtle-set turtles-on neighbors self)      
          ifelse (top - bottom) = 0
          [set satisfaction 0.5]
          [set satisfaction (my-group - bottom) / (top - bottom)]  
      
        ]
    if rule = 4 ;; si règle anticonf
      [
          let top-rule one-of majority-rules
          let bottom   -1 * count (turtle-set turtles-on neighbors self) with [rule = top-rule]/ count     (turtle-set turtles-on neighbors self) 
          let bottom-rule one-of minority-rules
          let top -1 * count (turtle-set turtles-on neighbors self) with [rule = bottom-rule]/ count     (turtle-set turtles-on neighbors self)     
          let my-rule rule
          let my-group -1 * count (turtle-set turtles-on neighbors self) with [rule = my-rule]/       count (turtle-set turtles-on neighbors self)      
          ifelse (top - bottom) = 0
          [set satisfaction 0.5]
          [set satisfaction (my-group - bottom) / (top - bottom)] 
        ]
    if not any? (turtles-on neighbors) ;; s’il n’y a pas de tortues voisines
  [set satisfaction 0]
end



to moving-stage
   ask turtles [if move? and not am-i-the-best? [move-agent]] ;; si on peut bouger et qu’on est pas le meilleur alors on bouge
end


to reset-decisions
  ask turtles [
  set move? false
  set rule? false
  set behavior? false
  ] 
end   


to replacement
  ask turtles [    
     let index1  age 
     let index2 (age + 1) 
     if index1 > 99 [set index1 99]
     if index2 > 99 [set index2 99]     
     let ex1 item index1 life-distribution ;;  associe l’espérance de vie par rapport à l’age
     let ex2 item index2 life-distribution ;;  associe l’espérance de vie par rapport à l’age     
     let prob-death 1 - (ex1 / (ex2 + 1))
     ifelse  random-float 1  < prob-death 
  [replace]
  [set age age + 1]
  ]
end   



to set-outputs
    set cooperation-rate count turtles with [cooperate?] / count turtles
    set fraction-best count turtles with [shape = "face happy"]/ count turtles
    set satisfaction-rate mean [satisfaction] of turtles
    set maxi count turtles with [rule = 1] / count turtles
    set mini count turtles with [rule = 2] / count turtles
    set conf count turtles with [rule = 3] / count turtles
   set anti count turtles with [rule = 4] / count turtles
end


to update-plot
  set-current-plot "cooperation"
  set-current-plot-pen "cooperation"
  plot cooperation-rate
  set-current-plot-pen "satisfaction"
  plot satisfaction-rate
  set-current-plot-pen "fraction-best"
  plot fraction-best 
  set-current-plot "population"
  set-current-plot-pen "maxi"
  plot maxi
  set-current-plot-pen "mini"
  plot mini
  set-current-plot-pen "conf"
  plot conf
  set-current-plot-pen "anti"
  plot anti
  set-current-plot "track"
  set-current-plot-pen "pen1"
  plot count turtles with [rule?]
  set-current-plot-pen "pen2"
  plot count turtles with [move?]
  end


to update-views
ask turtles [establish-color]
end

to establish-color  ;; couleur tortues en fiction de leur règle
  if rule = 1 
    [set color red
      ]
  if rule = 2
    [set color green
      ]
  if rule = 3
    [set color blue
      ]
  if rule = 4  
    [set color white
      ]
end


to replace  
    ifelse random-float 1.0 < 0.5 
  [set cooperate? true]
  [set cooperate? false]        
    set age 0
    set rule? false
    set behavior? false
    set move? false
    set rule (random 4) + 1
 
end




to init-age-FR2011 ;; initialisation de l’age grâce à la pyramide des ages

  let census-dist (list 0.01180683 0.01201037 0.01209845 0.01234063 0.01227253 0.01234422 0.01227801 0.01250872 0.01225243 0.01220084 0.01216063 0.01225841 0.01243949 0.01269816 0.01215054 0.01210297 0.01204218 0.01225426 0.01215026 0.01175250 0.01158990 0.01192538 0.01187672 0.01193472 0.01186481 0.01195931 0.01191443 0.01209404 0.01205728 0.01199851 0.01184490 0.01265457 0.01279754 0.01296898 0.01230444 0.01208202 0.01224300 0.01196657 0.01234141 0.01307640 0.01381147 0.01418162 0.01408421 0.01379278 0.01357054 0.01350406 0.01343341 0.01375896 0.01378147 0.01394149 0.01374521 0.01330135 0.01333475 0.01326854 0.01320184 0.01288553 0.01284952 0.01274903 0.01264137 0.01262325 0.01233349 0.01253659 0.01219221 0.01267168 0.01243927 0.01241485 0.01210161 0.01147030 0.00860238 0.00839324 0.00814365 0.00754129 0.00669977 0.00695507 0.00727191 0.00710799 0.00690240 0.00684548 0.00662450 0.00661433 0.00621870 0.00621606 0.00582400 0.00560822 0.00497965 0.00458912 0.00415829 0.00377767 0.00338402 0.00289983 0.00250650 0.00215533 0.00181251 0.00149459 0.00069600 0.00047605 0.00032965 0.00022167 0.00018668 0.00020581 0.00013013 0.00007982 0.00005118 0.00003188 0.00001312 0.00001378)

ask turtles [
    let temp-init random 106
    while [random-float 0.1 > item temp-init census-dist]
   [set temp-init random 106]
    set age temp-init
    ]
end



to set-life-distribution-FR2011 ;;Life expectation for ages according data colected by INSEE 2011 France métropolitaine                              

  set life-distribution (list 81.32 80.61 79.63 78.64 77.65 76.66 75.67 74.68 73.68 72.69 71.69 70.70 69.70 68.71 67.72 66.73 65.74 64.76 63.77 62.80 61.83 60.85 59.88 58.91 57.94 56.97 56.00 55.04 54.07 53.10 52.13 51.16 50.19 49.23 48.26 47.30 46.34 45.38 44.43 43.48 42.53 41.59 40.65 39.71 38.78 37.86 36.94 36.02 35.11 34.21 33.32 32.44 31.56 30.70 29.84 28.99 28.14 27.30 26.47 25.64 24.82 24.00 23.18 22.37 21.56 20.76 19.97 19.18 18.39 17.61 16.83 16.07 15.31 14.56 13.83 13.10 12.39 11.70 11.02 10.36 9.72 9.10 8.51 7.94 7.39 6.87 6.37 5.91 5.48 5.07 4.69 4.35 4.02 3.70 3.42 3.17 2.94 2.75 2.57 2.40 )

end



to-report majority-rules  ;; reports a set with the number of the most frequent rules in agent's neighborhood (agent included)
                          ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist [rule] of (turtle-set turtles-on neighbors self)
  set mylist modes mylist
  report mylist
end




to-report minority-rules ;; reports a set with the number of the less frequent rules in agent's neighborhood (agent included)
                         ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist_1 [rule] of (turtle-set turtles-on neighbors self)
  let mylist []
  let j 1
  while [empty? mylist] [
  let i 1
  repeat 4 [
    if length filter [? = i] mylist_1 = j  [set mylist lput i mylist] 
    set i i + 1
    ]
  set j j + 1
  ] 
  report mylist
end


to-report majority-rules-global  ;; reports a set with the number of the most frequent rules in agent's neighborhood (agent included)
                          ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist [rule] of turtles
  set mylist modes mylist
  report mylist
end




to-report minority-rules-global ;; reports a set with the number of the less frequent rules in agent's neighborhood (agent included)
                         ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist_1 [rule] of turtles
  let mylist []
  let j 1
  while [empty? mylist] [
  let i 1
  repeat 4 [
    if length filter [? = i] mylist_1 = j  [set mylist lput i mylist] 
    set i i + 1
    ]
  set j j + 1
  ] 
  report mylist
end



to-report majority-behavior 
  let mylist [cooperate?] of (turtle-set turtles-on neighbors self)
  report one-of modes mylist
end


to-report am-i-the-best? ;; reports true if the agents is the best in its neighborhood (according with its rule) and false otherwise
  let test false
  if any? turtles-on neighbors [
  if (rule = 1) and (score >= [score] of max-one-of turtles-on neighbors [score] * 0.99) [set test true]
  if (rule = 2) and (score <= [score] of min-one-of turtles-on neighbors [score] * 1.01) [set test true]
  if (rule = 3) and (member? rule majority-rules) [set test true]
  if (rule = 4) and (member? rule minority-rules) and not all? (turtles-on neighbors) [rule = 4] [set test true]  
  ]
  report test
end

to-report am-i-progressing?
  let test false
  if (rule = 1) and (score > last-score)
    [set test true]
  if (rule = 2) and (score < last-score)
    [set test true]
  if (rule = 3) and count-majority-rule > last-count-majority-rule
    [set test true]
  if (rule = 4) and count-minority-rule < last-count-minority-rule
    [set test true]
  report test
end

to-report am-i-the-best-global?
let test false

  if (rule = 1) and (score >= [score] of max-one-of turtles [score] * 0.99) 
     [set test true]
  if (rule = 2) and (score <= [score] of min-one-of turtles [score] * 1.01) 
     [set test true]
  if (rule = 3) and (member? rule majority-rules-global) and all? turtles [rule = 3] 
     [set test true]
  if (rule = 4) and (member? rule minority-rules-global) and not all? turtles [rule = 4] 
     [set test true]  
  

report test
end


to-report best-elements ;; report a list with the agents with the best performance according agents
  
  let myset (turtle-set turtles-on neighbors self)
  if rule = 1 [set myset myset with [score >= [score] of max-one-of myset [score] * 0.99]]
  
  if rule = 2 [set myset myset with [score <= [score] of min-one-of myset [score] * 1.1]]
  if rule = 3 [
    let rules-list majority-rules
    set myset myset with [member? rule rules-list]
    ] 
  if rule = 4 [
    let rules-list minority-rules
    if not empty? rules-list [
    set myset myset with [member? rule rules-list]
    ]  
  ]
  report myset
end  


to-report best-elements-global ;; report a list with the agents with the best performance according agents
  
  let myset turtles ;; myset : l'espace de toutes les tortues
  if rule = 1 [set myset myset with [score >= [score] of max-one-of myset [score] * 0.99]]
  
  if rule = 2 [set myset myset with [score <= [score] of min-one-of myset [score] * 1.1]]
  if rule = 3 [
    let rules-list majority-rules-global
    set myset myset with [member? rule rules-list]
    ] 
  if rule = 4 [
    let rules-list minority-rules-global
    if not empty? rules-list [
    set myset myset with [member? rule rules-list]
    ]  
  ]
  report myset
end 


to-report is-my-rule-the-best? ;; reports true if the agent's rule is used by any of the best valuated agents in its neighborhood (according with its rule) and false otherwise
  let test false
  ifelse am-i-the-best? [set test true][
  if member? rule [rule] of best-elements [set test true] 
  ]
  report test
end



to select-rule
                 ;; the agent changes its rule if every more succesfull neighbor has a different rule (if them exist).
                 ;; The agent never change his rule nor behavior if is in the set of agents with best performance (according its rule)
     
      if not am-i-progressing? 
    [ if not am-i-the-best? 
     [
     if not is-my-rule-the-best?   
         [copy-strategy (one-of best-elements)]
      ]
     ] 
     
     
     
   ;  if not am-i-progressing? 
   ; [ ifelse am-i-the-best? 
   ;  [
   ;  if not am-i-the-best-global? 
    ;     [copy-strategy (one-of best-elements-global)]
    ;  ]
    ; [
    ; if not is-my-rule-the-best?   
    ;     [copy-strategy (one-of best-elements)]
     ; ]
     ;] 
end


to copy-strategy [temp-agent]
  
      set rule [rule] of temp-agent 
      set theta_1 [theta_1] of temp-agent 
      set theta_1 add-noise "theta_1" Transcription-error
            
      set theta_2 [theta_2] of temp-agent 
      set theta_2 add-noise "theta_2" Transcription-error
      
     if rule = 1 ;; si règle maxi
      [
          set weighting-history-maxi [weighting-history-maxi] of temp-agent
          set likelihood-to-move add-noise "weighting-history-maxi" Transcription-error 
        ]
    if rule = 2 ;; si règle mini
      [
         set weighting-history-mini [weighting-history-mini] of temp-agent
         set likelihood-to-move add-noise "weighting-history-mini" Transcription-error 
        ]
    if rule = 3 ;; si règle conf
      [
           set weighting-history-conf [weighting-history-conf] of temp-agent
           set likelihood-to-move add-noise "weighting-history-conf" Transcription-error 
        ]
    if rule = 4 ;; si règle anticonf
      [
          set weighting-history-anti [weighting-history-anti] of temp-agent
          set likelihood-to-move add-noise "weighting-history-anti" Transcription-error 
        ]
      
      set likelihood-to-move [likelihood-to-move] of temp-agent 
      set likelihood-to-move add-noise "likelihood-to-move" Transcription-error
      
     
end


to-report add-noise [value noise-std]
      let epsilon random-normal 0.0 noise-std
      if ( epsilon <= -100 )
      [ set epsilon -99] 
      let noisy-value runresult value * epsilon * random-normal 0.0 noise-std
      if (noisy-value > 1) [set noisy-value 1]
      if (noisy-value < 0) [set noisy-value 0]     
      report noisy-value
end


to select-behavior  ;; patch procedure
  if any? turtles-on neighbors
  [
  if (rule = 1) or (rule = 2) 
  [set cooperate? [cooperate?] of one-of best-elements]
                                                                ;;choose behavior (cooperate. not cooperate)
                                                                ;; of neighbor who performed best according
                                                                ;; the agent's rule 
  
  if rule = 3
  [set cooperate? majority-behavior]                                                              
  if rule = 4 
  [set cooperate? not majority-behavior]
  ]   
end


to move-agent
 
   if any? turtles-on neighbors ;; s’il y a conflict 
    [
      let target one-of other best-elements
      if target = nobody 
  [set target one-of turtles-on neighbors] ;; s’il n’y a pas de target on dit que target est un des voisins de la tortue
      ifelse random-float 1 < (1 - satisfaction)*(1 - [satisfaction] of target) 
      [interchange-agents target] ;; si
      [move-to-empty] ;; sinon exécuter move-to-empty
    ]
end




to move-to-empty
  if any? neighbors with [not any? turtles-here] ;; si il y a des voisinages sans tortue
  [move-to one-of neighbors with [not any? turtles-here]] ;; bouger la tortue vers le voisinage sans tortue
end


to interchange-agents [my-target]
   let my-patch patch-here
   let target-patch patch-here
   ask my-target [
     set target-patch patch-here
     move-to my-patch
     ]  
   move-to target-patch 
end
@#$#@#$#@
GRAPHICS-WINDOW
260
10
682
478
16
17
12.5
1
10
1
1
1
0
1
1
1
-16
16
-17
17
0
0
1
ticks
30.0

SWITCH
6
43
138
76
random-init
random-init
1
1
-1000

SLIDER
5
270
234
303
Initial-prob-update-behavior
Initial-prob-update-behavior
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
5
309
209
342
Initial-prob-update-rule
Initial-prob-update-rule
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
4
347
245
380
Initial-weighting-history
Initial-weighting-history
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
4
385
178
418
Initial-like-to-move
Initial-like-to-move
0
1
1
0.1
1
NIL
HORIZONTAL

BUTTON
155
21
218
54
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
151
73
217
106
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
704
10
904
160
cooperation
NIL
NIL
0.0
100.0
0.0
1.0
true
true
"" ""
PENS
"cooperation" 1.0 0 -16777216 true "" ""
"satisfaction" 1.0 0 -11221820 true "" ""
"fraction-best" 1.0 0 -2674135 true "" ""

PLOT
955
10
1155
160
population
NIL
NIL
0.0
100.0
0.0
1.0
true
true
"" ""
PENS
"maxi" 1.0 0 -2674135 true "" ""
"mini" 1.0 0 -10899396 true "" ""
"conf" 1.0 0 -13345367 true "" ""
"anti" 1.0 0 -16448764 true "" ""

PLOT
739
200
939
350
track
NIL
NIL
0.0
100.0
0.0
1.0
true
true
"" ""
PENS
"pen1" 1.0 0 -955883 true "" ""
"pen2" 1.0 0 -5825686 true "" ""

SLIDER
6
233
183
266
Transcription-error
Transcription-error
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
6
116
191
149
strength-of-dilemma
strength-of-dilemma
0
0.5
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
5
153
177
186
density
density
0
1
1
0.1
1
NIL
HORIZONTAL

SLIDER
6
191
178
224
inicoop
inicoop
0
100
50
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.5
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
