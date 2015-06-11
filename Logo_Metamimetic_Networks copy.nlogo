extensions [ nw ]



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Declare Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 globals [ 
;; Globals that come from the widget 
Topology                    ;type of graph
Num-Agents                  ;number of turtles
Connection-Probability      ;for random network
Initial-Neighbours          ;for small world network
Rewiring-Probability        
Scale-Free-Exponent         ;for scale-free network
Initial-Random-Types?       ;Agents' types initialization
Initial-Maxi-% 
Initial-Mini-% 
Initial-Conf-% 
Initial-Anti-% 
Strength-of-Dilemma         ;prisoner's dilemma
inicoop
replacement?
cultural-constant
load-topology?


FileIn
FileOut

;stopping condition
lAvg
condition
cooperation-list
avg1 
avg2  
var1 
var2 

;NETWORK CONSTRUCTION
;for scale-free
graphical?
sequence
p_k
Z
uniform
;for connectivity
success?

;;appearance 
sizeT
radius

;;OUTPUTS
  cooperation-rate
  satisfaction-rate
  satisfaction-rate2

life-expectation
mortality-rate
prob-to-die 
prob-die-imitation
infinity


;;IN THE NETWORK CONTEXT
;  clustering-coefficient               ;; average of clustering coefficients of all turtles
;  average-path-length                  ;; average path length of the network
;  network-density
;  diameter
;  n-links
;  clustering-coefficient-2


;TURTLE POPULATION
  maxi
  mini
  conf
  anti
;perception 
]


turtles-own [
  cooperate       ;; patch will cooperate
  my.rule             ;; patch will have one of four rules: 1=Maxi 2=mini 3=conformist 4=anticonformist  
  score            ;; score resulting from interaction of neighboring patches. It is dictated by the PD payoffs and the discount factor
  last.score
  inst.score
;  satisfaction
  satisfaction2
  age
  chances.imitations  

  rule?
  behavior?

;for network computations
;%%%%%
;distance-from-other-turtles
degree
free-stubs
;node-clustering-coefficient
;betweenness-centrality
;eigenvector-centrality
;page-rank
;closeness-centrality
;longest-path
;mean-path

;time since last changes 
time.rule
time.behavior
n.changes
n.changes.behavior
n.changes.list 
time.rule.list 
time.behavior.list
rule.at.death.list
age.at.death.list

rule.history
time.history
ticks.history
counter.age 
counter.ticks
age.history 

;for outputs
;  theta_1
;  theta_2
;  weighting-history
;  copy-error-rule
;  copy-error-behavior
 
run.info 
]

links-own[
; for small-world 
 rewired?
  ]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup
clear-all

;always need to be setup
set Num-Agents *-Num-Agents
set Topology *-Topology
set Strength-of-Dilemma *-strength-of-dilemma
set inicoop *-inicoop
set replacement? *-replacement?
set cultural-constant *-cultural-constant
set load-topology? Load-Topology
set FileIn *-fileIn
let seed random 2000000000
random-seed seed



;only setup if RN
if Topology = "Random" [set Connection-Probability *-Connection-Probability]

;only setup if SW
if Topology = "Small-World" [
                               set Initial-Neighbours  *-Initial-Neighbours 
                               set Rewiring-Probability *-Rewiring-Probability
                               ]

if Topology = "Scale-Free" [set Scale-Free-Exponent *-Scale-Free-Exponent]
     
 
set Initial-Random-Types? *-Initial-Random-Types?
ifelse not Initial-Random-Types?
      [
      set Initial-Maxi-% *-Initial-Maxi-%
      set Initial-Mini-% *-Initial-Mini-%
      set Initial-Conf-% *-Initial-Conf-%
      set Initial-Anti-% (100 - Initial-Conf-% - Initial-Mini-% - Initial-Maxi-%)
      ]
      [
      set Initial-Maxi-% (random-float 1) * 100
      set Initial-Mini-% (random-float (1 - Initial-Maxi-%)) * 100 
      set Initial-Conf-% (random-float (1 - Initial-Maxi-% - Initial-Mini-%)) * 100
      set Initial-Anti-% (100 - Initial-Conf-% - Initial-Mini-% - Initial-Maxi-%)
      ]

;set Transcription-error 1
;set PER *-p-Error-Copy-Rule
;set PEB *-p-Error-Copy-Behavior

set radius ( ( min (list world-width world-height) ) / 2 - 1)  
set FileOut (word Rewiring-Probability  "_" inicoop "_" seed "_" Strength-of-Dilemma "_" cultural-constant "_" Initial-Neighbours "_" replacement? )
common-setup
end

to common-setup
set Initial-Anti-% (100 - Initial-Conf-% - Initial-Mini-% - Initial-Maxi-%)
set infinity Num-Agents * 100
set success? false
set condition false
set cooperation-list []
set avg1 0
set avg2 0 
set var1 0
set var2 0
set lAvg 50

ifelse not load-topology? [setup-Topology] 
;[nw:load-matrix FileName turtles links
;; ask links [set color gray]
;]
[
 nw:load-graphml FileIn 
 nw:set-context turtles links
]

set Num-Agents count turtles

setup-init-turtles

if Topology != "Lattice" [ask turtles [set size 3]]
set sizeT [size] of one-of turtles 

set-life-distribution-USA2010
;if replacement? [
;                 init-age-USA2010
;                ]

reset-ticks
;set average-path-length nw:mean-path-length
;set diameter max [longest-path] of turtles  
;set clustering-coefficient mean  [ node-clustering-coefficient ] of turtles
;set clustering-coefficient-2 global-clustering-coefficient
;set network-density count links * 2 / ( (Num-Agents - 1) * (Num-Agents))
;set shuffled2? false
;set n-links count links 
;set repetitions 0
;set mincc min [node-clustering-coefficient] of turtles
;set mindeg min [degree] of turtles
;set original-degrees [degree] of turtles
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Open Mole Routines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to run-to-grid [tmax]
common-setup
while [not condition and ticks < tmax ][go]
set-last-measures
reset-ticks
end 

to run-Logo [tmax]  
while [not condition and ticks < tmax] [go]
set-last-measures
end


to-report go-stop?
let res true
let a1 max (list avg1 avg2)
let a2 min (list avg1 avg2)
let v1 max (list var1 var2)
let v2 min (list var1 var2)

let c1 (a1 - a2)   
let c2 (v1 - v2) 

ifelse  c1 < .03 and c2 < .005 [set res true][set res false]
if  c2 = 0 and c2 = 0 [set res true ] 
if  majority != 3 and replacement? [set res false] 

report res
end

to-report majority
let lista (list maxi mini conf anti)
let lista2 sort lista
report (( position (item  3 lista2 ) lista ) + 1)
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Measures ;;;;;;;;;; ;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to set-outputs
  ;populations
let turtles-maxi turtles with [ my.rule  = 1]
let turtles-mini turtles with [ my.rule  = 2]
let turtles-conf turtles with [ my.rule  = 3]
let turtles-anti turtles with [ my.rule  = 4]


set maxi count turtles-maxi  
set mini count turtles-mini  
set conf count turtles-conf  
set anti count turtles-anti   

set cooperation-rate count turtles with [cooperate] / Num-Agents
;set satisfaction-rate count turtles with [shape = "face happy"] / Num-Agents
set satisfaction-rate2  mean [satisfaction2] of turtles

;;;##FILL STOP CONDITION MEASURES
ifelse length cooperation-list < lAvg
[set cooperation-list fput cooperation-rate cooperation-list]
[
 set cooperation-list fput cooperation-rate cooperation-list
 set cooperation-list remove-item (lAvg - 1) cooperation-list
if ticks = 150 [set avg1 mean cooperation-list
                set var1 sqrt variance cooperation-list
               ]

if ticks = 200 [
               set avg2 mean cooperation-list
               set var2 sqrt variance cooperation-list
               set condition go-stop?
               ]
if ticks mod 50 = 0 and ticks > 200 [
               set avg1 avg2
               set var1 var2
               set avg2 mean cooperation-list
               set var2 sqrt variance cooperation-list
               set condition go-stop?
               ]
]  
end

to export-graphL
let name (word FileOut "_graph.graphml")
nw:save-graphml name
end 
to export-coopL
let name (word FileOut "_coop.csv")
export-plot "Cooperation and Satisfaction" name 
end
to export-propL
let name (word FileOut "_popul.csv")
export-plot "Population" name
end
to export-agesL
let name (word FileOut "_ages.csv")
export-plot "Age Plot" name 
end

to export-graph
nw:save-graphml "graph.graphml"
end 
to export-coop
export-plot "Cooperation and Satisfaction" "coop.csv" 
end
to export-prop
export-plot "Population" "popul.csv"
end
  to export-ages
export-plot "Age Plot" "ages.csv" 
end

to set-last-measures
ask turtles 
[
set rule.history lput my.rule rule.history
set time.history lput (age - counter.age) time.history
set ticks.history lput (ticks - counter.ticks) ticks.history 
set age.history lput age age.history 
]
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup Turtles ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to setup-init-turtles

if-else Initial-Random-Types? [ask turtles [set my.rule (random 4) + 1]]      
  [
   ask n-of (floor (Initial-Maxi-% * Num-Agents  / 100 )) turtles [set my.rule 1]
   ask n-of floor ((Initial-Mini-% * Num-Agents / 100 )) turtles with [my.rule != 1] [set my.rule 2]
   ask n-of floor ((Initial-Conf-% * Num-Agents / 100 )) turtles with [my.rule != 1 and my.rule != 2] [set my.rule 3]
   ask turtles with [my.rule != 1 and my.rule != 2 and my.rule != 3] [set my.rule 4]
  ]
 
ask turtles [      
     set shape "face sad"
     set size sizeT
     set age 0
     set satisfaction2 1
     ifelse random-float 1.0 < (inicoop / 100)
        [set cooperate true]
        [set cooperate false]
     establish-color
     set score 0.0
     set rule? false
     set behavior? false

set time.rule 0
set time.behavior 0
set n.changes 0
set n.changes.behavior 0

set chances.imitations 0
;set perception 0 

set n.changes.list []
set time.rule.list []
set rule.at.death.list []
set time.behavior.list []
set age.at.death.list  []
set run.info (word Topology  "*" Strength-of-Dilemma "*" inicoop "*" replacement? "*" cultural-constant "*" Rewiring-Probability "*" Initial-Neighbours "*" Connection-Probability "*" Scale-Free-Exponent "*" Initial-Random-Types? "*" load-topology? "*" Num-Agents )

set rule.history []
set time.history []
set ticks.history []
set age.history []
set counter.ticks 0 
set counter.age 0 

       
;set betweenness-centrality nw:betweenness-centrality
;set eigenvector-centrality nw:eigenvector-centrality
;set page-rank nw:page-rank
;set closeness-centrality nw:closeness-centrality
;set node-clustering-coefficient nw:clustering-coefficient 
]
end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; To Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to go
;;;;;;;;;;;;;;;;;;;;;
;uncomment to change dynamically on widget
;set Strength-of-Dilemma *-strength-of-dilemma
;set inicoop *-inicoop
;set replacement? *-replacement?
;set cultural-constant *-cultural-constant
;if replacement? [set-life-distribution-USA2010]
;;;;;;;;;;;;;;;;;;;;;

ask turtles [interact]
decision-stage
learn-stage

;;;;;;;;;;;;;;;;;;;;;;;
;uncomment to view changes widget
;ask turtles [establish-color]
;ask turtles [set-faces]
;;;;;;;;;;;;;;;;;;;;;;;

ask turtles [set satisfaction2 satisfaction-2]

set-outputs            
my-update-plots
reset-change

ask turtles [set chances.imitations chances.imitations + 1
             
             ifelse replacement? 
             [
             if  chances.imitations >= cultural-constant   [set age age + 1
                                                      set chances.imitations 0
                                                     ]
             ][set age age + 1]
            ]
if replacement? [replacement]
tick
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;              Go Routines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to reset-change
ask turtles   [
              set rule? false
              set behavior? false
              ]
end

to set-faces
ifelse am-i-the-best?   [set shape "face happy"]
                        [set shape "face sad"]                          
end

to interact  ;; calculates the agents' payoffs for Prisioner's Dilema.
let total-cooperators count link-neighbors with [cooperate]
set inst.score 0
ifelse cooperate
    [set inst.score (total-cooperators * (1 - Strength-of-Dilemma) / count link-neighbors)]
    [set inst.score ((total-cooperators + (count link-neighbors - total-cooperators) * Strength-of-Dilemma ) / count link-neighbors)]  
set last.score score
set score inst.score
end


to-report am-i-the-best? ;; reports true if the agent is the best in its neighborhood
 let test false  
 if ( my.rule  = 1) and  (score >= [score] of max-one-of link-neighbors [score]  * 0.99)  [set test true]
 if ( my.rule  = 2) and  (score <= [score] of min-one-of link-neighbors [score] * 1.01)     [set test true]
 if ( my.rule  = 3) and  (member? my.rule majority-rules)                                      [set test true]
 if ( my.rule  = 4) and  (member? my.rule minority-rules) and not all? (link-neighbors) [ my.rule  = 4]  [set test true]    
 report test
end

to decision-stage
ask turtles [
  
  let satisfaction  am-i-the-best? ;  
;  if error_on_satisfaction
;  [
;  if random-float 1 <= copy-error-rule ;
;     [set satisfaction not am-i-the-best?]
;  ]

  
if not satisfaction
[
;if random-float 1 <= theta ;only some agents will be allowed to change rule
;      [
      set rule? true 
      set behavior? true
;      ]
       
; if random-float 1 <= theta  
;      [set behavior? true]
]

if age < 15 
    [set rule? false]

]
end

to learn-stage
ask turtles 
[
if rule? [select-rule]
if behavior? [select-behavior]
]
end


to-report is-my-rule-the-best? ;; reports true if the agent's my.rule is used by any of the best valuated agents in its neighborhood (according with its rule) and false otherwise
  let test false
  ifelse am-i-the-best? [set test true][
  if member? my.rule [my.rule] of best-elements [set test true] 
  ]
  report test
end

; choose strategy if your rule is not the best, if innovate? choose rule if you are unsatisfied
to select-rule              
  ;ifelse not is-my-rule-the-best?   
   if not is-my-rule-the-best?   
   [copy-strategy (one-of best-elements)]         
   
   ;[if not am-i-the-best? and member? rule [rule] of best-elements and innovate? ;stuck agent will innovate with probability error-copy
   ;    [set rule (random 4 + 1)]
   ;]
end



to copy-strategy [temp-agent]
;;;RULE STEP
;ifelse random-float 1.0 > copy-error-rule ; some agents do the right thing
;       [
       set rule.history lput my.rule rule.history
       set time.history lput (age - counter.age ) time.history
       set age.history lput age age.history  
       set ticks.history lput (ticks - counter.ticks ) ticks.history 
       set counter.age age 
       set counter.ticks ticks

       set my.rule [my.rule] of temp-agent

;      set theta_1 [theta_1] of temp-agent       
;         set theta_2 [theta_2] of temp-agent 
;         if Copy-Thetas? [
;         set theta_1 add-noise "theta_1" Transcription-Error
;         set theta_2 add-noise "theta_2" Transcription-Error
;                         ]
;       ]     
;       [set my.rule random 4 + 1 ] ;do a random thing
;       
       set n.changes (n.changes + 1)
       set rule? false
       set time.rule age


             
end



to select-behavior 
;ifelse random-float 1 > copy-error-behavior ;only some agents do the right thing 
;       [ 
       if ( my.rule  = 1) or ( my.rule  = 2) [set cooperate [cooperate] of one-of best-elements ]
       if  my.rule = 3                 [set cooperate majority-behavior]         
       if my.rule = 4                 [set cooperate not majority-behavior]
;       ]
;      [
;      ifelse random-float 1.0 < .5  [set cooperate true] [set cooperate false] ;choose random behaviour
;      ]
set behavior? false
set n.changes.behavior (n.changes.behavior + 1)
set time.behavior age
end 


to-report majority-behavior
  let mylist [cooperate] of (turtle-set link-neighbors self)
  report one-of modes mylist
end

to-report satisfaction-2
let sat2 0
let myset (turtle-set link-neighbors self)
 
if my.rule = 1 [
            ifelse abs(max [score] of myset - min [score] of myset) = 0
            [set sat2 1]
            [set sat2  ( (score  - min [score] of myset ) / (max [score] of myset - min [score] of myset))] 
            ]                          

if my.rule = 2 [
            ifelse   (max [score] of myset - min [score] of myset) = 0
            [set sat2 1] 
            [set sat2  ( ( max [score] of myset - score  ) / ( max [score] of myset - min [score] of myset ))] 
            ]              

if my.rule = 3 [
            let my-frequency ( count link-neighbors with [ my.rule  = 3] + 1 ) / (count link-neighbors + 1)
            ifelse abs(min-frequency - max-frequency) = 0 
                                                         [set sat2 1]
                                                         [set sat2  (my-frequency - min-frequency) / (max-frequency - min-frequency)]
            ]

if my.rule = 4 [
            let my-frequency (count link-neighbors with [ my.rule  = 4]  + 1) / ( count link-neighbors + 1)
            ifelse abs( max-frequency - min-frequency ) = 0 
                                                       [set sat2 1]
                                                       [set sat2  ( max-frequency - my-frequency ) / (  max-frequency - min-frequency)]
            ]

report sat2
end


to-report majority-rules  ;; reports a set with the number of the most frequent rules in agent's neighborhood (agent included)
                          ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist [ my.rule ] of (turtle-set link-neighbors self)
  set mylist modes mylist
  report mylist
end

to-report minority-rules ;; reports a set with the number of the less frequent rules in agent's neighborhood (agent included)
                         ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist_1 [ my.rule ] of (turtle-set link-neighbors self)
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


to-report best-elements ;; report a list with the agents with the best performance according to agents  
  let myset (turtle-set link-neighbors self)
  if my.rule = 1 [set myset myset with [score >= [score] of max-one-of myset [score] * 0.99]]
  
  if my.rule = 2 [set myset myset with [score <= [score] of min-one-of myset [score] * 1.01]]
  
  if my.rule = 3 [
              let rules-list majority-rules
              set myset myset with [member? my.rule rules-list]
              ] 
  if my.rule = 4 [
              let rules-list minority-rules
              if not empty? rules-list [
                                        set myset myset with [member? my.rule rules-list]
                                       ]  
              ]
  
  report myset
end  

to-report add-noise [value noise-std]
      let epsilon random-normal 0.0 noise-std
      if ( epsilon <= -100 )
      [ set epsilon -99] 
      let noisy-value runresult value * 100 / ( 100 + epsilon )
      if (noisy-value > 1) [set noisy-value 1]
      if (noisy-value < 0) [set noisy-value 0]     
      report noisy-value
end


to-report min-frequency
let l item 0 minority-rules
report count (turtle-set link-neighbors self) with [ my.rule  = l] / (count link-neighbors + 1)
end

to-report max-frequency
let l item 0 majority-rules
report count (turtle-set link-neighbors self) with [ my.rule  = l] / (count link-neighbors + 1)
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Life Distributions  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;census-dist : fractions of people with age 0, 5, ...100
;life-expect   : expected life at ages 0, 5, ...100 (life expectancy = 1/M_age)

;expected rate at which people die per unit time at each age* = M_age* 
;probability of dying at age* = 1-exp(-M_age*) :: 

;F_age*= fraction of population of age* that dies within one year :: M_age*=-ln(1-F_age*)

;if M is done in intervals (as we have here), M is the value at age A+5


to init-age-USA2010 ;;Population fraction for ages according data colected
                                 ;By Lindsay M. Howden and Julie A. Meyer in
                                 ;Age and Sex Composition: 2010 Census briefs
                                 ;Reported fractions have an interval of 5 years starting from 0 until 100 years
  let census-dist (list 0.0654 0.0659 0.0670 0.0714 0.0699 0.0683 0.0647 0.0654 0.0677 0.0735 0.0722 0.0637 0.0545 0.0403 0.0301 0.0237 0.0186 0.0117 0.0047 0.0012 0.0002)
  
  ask turtles [
    
    let index floor random 21
    while [random-float 1 > item index census-dist]
          [
          set index floor random 21
          ]
    set age   ( (index) * 5 + random 5)
              ]
end



to set-life-distribution-USA2010 ;;Life expectation for ages according data colected by the Centers for Disease Control
                                 ;and Prevention’s National Center for Health Statistics (NCHS) USA 2010
                                 ;Murphy, Xu, and Kochanek 'Deaths: preliminary data 2010' National Vital Stat. Reports 60-4
                                 ;Reported ages have an interval of 5 years starting from 0 until 100 years

set life-expectation (list 78.7 74.3 69.3 64.4 59.5 54.8 50.0 45.3 40.6 36.0 31.5 27.2 23.1 19.2 15.5 12.2 9.2 6.6 4.7 3.3 2.4) 
set mortality-rate map [1 / ?] life-expectation
set prob-to-die map [ (1 - exp ( ( - 1 ) * ? )  )] mortality-rate 
set prob-die-imitation map [( 1 - exp (  ( ln ( 1 - ? )) / cultural-constant )) ] prob-to-die
end

to-report prob-die
let index ceiling ( floor ( age   / 5 )) 
if index > 20 [set index 20]
if index < 0  [set index 0]

let p.die item (index) prob-die-imitation
report p.die 

;let mortality item index mortality-rate 
;let prob-to-die ( 1 - exp ( (- 1 ) *  mortality ) )
;let prob-die-imitation ( 1 - exp (  (ln ( 1 - prob-to-die )) / cultural-constant ))
;report prob-die-imitation 
end


to replacement
  ask turtles [    
  if      random-float 1  < prob-die 
             [
             set-info-death
             replace
             set shape "target"
             ]
       ]
end   

to set-info-death
set n.changes.list lput n.changes n.changes.list
set time.rule.list lput time.rule time.rule.list
set time.behavior.list lput time.behavior time.behavior.list

set rule.at.death.list lput my.rule rule.at.death.list
set age.at.death.list lput age age.at.death.list

set rule.history lput my.rule rule.history
set time.history lput (age - counter.age) time.history
set ticks.history lput (ticks - counter.ticks + 1) ticks.history 
set age.history lput (age ) age.history 
end

to replace  
    set age 0
    set rule? false
    set behavior? false
    set my.rule (random 4) + 1 
    set shape "face sad"
    set size sizeT
    set satisfaction2 1
    ifelse random-float 1.0 < .5 ;(inicoop / 100)
        [set cooperate true]
        [set cooperate false]
    establish-color
    set score 0.0
    set rule? false
    set behavior? false
set chances.imitations 0
set time.rule 0
set n.changes 0
set n.changes.behavior 0
set time.behavior 0
;set shuffled? false

set counter.age age 
set counter.ticks ticks
end




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Layout  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Layout code citation
;Wilensky, U. (2005). NetLogo Preferential Attachment model. http://ccl.northwestern.edu/netlogo/models/PreferentialAttachment. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
;Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

;; resize-nodes, change back and forth from size based on degree to a size of 1
to resize-nodes
  ifelse all? turtles [size <= 1]
  [
    ;; a node is a circle with diameter determined by
    ;; the SIZE variable; using SQRT makes the circle's
    ;; area proportional to its degree
    ask turtles [ set size sqrt count link-neighbors ]
  ]
  [
    ask turtles [ set size 1 ]
  ]
end


to layout
  ;; the number here is arbitrary; more repetitions slows down the
  ;; model, but too few gives poor layouts
  repeat 10 [
    ;; the more turtles we have to fit into the same amount of space,
    ;; the smaller the inputs to layout-spring we'll need to use
    let factor sqrt count turtles
    ;; numbers here are arbitrarily chosen for pleasing appearance
    layout-spring turtles links (1 / factor) (7 / factor) (1 / factor)
 ;  layout-spring (turtles) links 0.4 6 1

;    display  ;; for smooth animation
  ]
  ;; don't bump the edges of the world
  let x-offset max [xcor] of turtles + min [xcor] of turtles
  let y-offset max [ycor] of turtles + min [ycor] of turtles
  ;; big jumps look funny, so only adjust a little each time
  set x-offset limit-magnitude x-offset 0.1
  set y-offset limit-magnitude y-offset 0.1
  ask turtles [ setxy (xcor - x-offset / 2) (ycor - y-offset / 2) ]
end

to-report limit-magnitude [number limit]
  if number > limit [ report limit ]
  if number < (- limit) [ report (- limit) ]
  report number
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup Topologies  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to setup-Topology
  if-else Topology = "Lattice"       [Create-Lattice]
    [
    if-else Topology = "Random"        [Create-Random-Network]
      [if-else Topology = "Small-World" [Create-Small-World]
          [if-else Topology = "Barabasi-Albert" [Create-Barabasi] [Create-Scale-Free]]                                                  
      ]
    ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Lattice ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to Create-Lattice 

;let size-lattice floor sqrt Num-Agents
;nw:generate-lattice-2d turtles links size-lattice size-lattice true 

let rows  floor (sqrt Num-Agents )
let columns ( floor (Num-Agents / rows ) ) 

set rows ( rows / 2 ) 
set columns ( columns / 2 ) 

let myPatches patches with [ abs (pxcor ) <= rows and abs (pycor ) <= columns ]

ask myPatches [sprout 1] ;Num-Agents
ask turtles [create-links-with turtles-on neighbors]

;wrap world 
let maxxcor max [xcor] of turtles
let minxcor min [xcor] of turtles
let maxycor max [ycor] of turtles
let minycor min [ycor] of turtles

let rightcorner patches with   [pxcor = maxxcor]
let leftcorner patches  with   [pxcor = minxcor]
let bottomcorner patches with  [pycor = maxycor]
let topcorner patches with     [pycor = minycor] 

set rightcorner turtles-on rightcorner
set leftcorner turtles-on leftcorner
set bottomcorner turtles-on bottomcorner
set topcorner turtles-on topcorner

ask rightcorner [create-links-with leftcorner with [ pycor = [pycor] of myself ]]
ask rightcorner [create-links-with leftcorner with [ pycor = [pycor + 1] of myself]]
ask rightcorner [create-links-with leftcorner with [ pycor = [pycor - 1] of myself ]]

ask bottomcorner [create-links-with topcorner with [ pxcor = [pxcor] of myself ]]
ask bottomcorner [create-links-with topcorner with [ pxcor = [pxcor + 1 ] of myself ]]
ask bottomcorner [create-links-with topcorner with [ pxcor = [pxcor - 1] of myself  ]]


let corners (patch-set  patch minxcor minycor patch minxcor maxycor patch maxxcor maxycor patch maxxcor minycor)
ask turtles-on corners [create-links-with other turtles-on corners] 

;ask links [set color black]

set success? true
;set average-path-length nw:mean-path-length 
spread-turtles
set sizeT [size] of one-of turtles 


end

to spread-turtles
let num-rows  length remove-duplicates sort [ycor] of turtles
let num-cols  length remove-duplicates sort [xcor] of turtles 

let horizontal-spacing (world-width / num-cols) 
let vertical-spacing   (world-height / num-rows) 
;let min-xpos (min-pxcor - 0.5 + horizontal-spacing / 2) 
;let min-ypos (min-pycor - 0.5 + vertical-spacing / 2) 


ask turtles [ 
     let x ( xcor * horizontal-spacing)
     let y ( ycor * vertical-spacing) 
     setxy (x) (y) 
] 

;ask turtles [set size ceiling sqrt distance  (  one-of link-neighbors ) * 1.5]
ask turtles [set size min (list horizontal-spacing vertical-spacing)]
end


;to resize-turtles
;let num-rows  length remove-duplicates sort [ycor] of turtles
;let num-cols  length remove-duplicates sort [xcor] of turtles 
;
;let horizontal-spacing (world-width / num-cols) 
;let vertical-spacing   (world-height / num-rows) 
;;let min-xpos (min-pxcor - 0.5 + horizontal-spacing / 2) 
;;let min-ypos (min-pycor - 0.5 + vertical-spacing / 2) 
;
;;ask turtles [set size ceiling sqrt distance  (  one-of link-neighbors ) * 1.5]
;set sizeT min (list horizontal-spacing vertical-spacing)
;ask turtles [set size sizeT]
;end

;to lattice-2
;ask patches [sprout 1] ;Num-Agents
;ask turtles [create-links-with turtles-on neighbors]
;
;let max-x max [pxcor] of patches
;let min-x min [pxcor] of patches
;let max-y max [pycor] of patches
;let min-y min [pycor] of patches
;;wrap world 
;ask turtles with [xcor = max-x and ycor < max-y and ycor > min-y] [
;                                                                  create-links-with turtles-on (patch-set (patch min-x ycor) (patch min-x (ycor + 1)) (patch min-x (ycor - 1)))
;                                                                  ]
;ask turtles with [ycor = min-y and xcor < max-x and xcor > min-x] [
;                                                                  create-links-with turtles-on (patch-set (patch xcor max-y) (patch (xcor - 1) max-y) (patch (xcor + 1) max-y))
;                                                                  ]
;ask turtles with [xcor = min-x and ycor < max-y and ycor > min-y and count link-neighbors < 8] [
;                                                                  create-links-with turtles-on (patch-set (patch max-x ycor) (patch max-x (ycor + 1)) (patch max-x (ycor - 1)))
;                                                                  ]
;ask turtles with [ycor = max-y and xcor < max-x and xcor > min-x and count link-neighbors < 8] [
;                                                                  create-links-with turtles-on (patch-set (patch xcor min-y) (patch (xcor - 1) min-y) (patch (xcor + 1) min-y))
;                                                                  ]
;
;let corners (patch-set  patch min-x min-y patch min-x max-y  patch max-x max-y patch max-x min-y)
;ask turtles-on corners [create-links-with other turtles-on corners] 
;ask links [set color black]
;
;set success? true
;end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Random Network ;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to Create-Random-Network 
  ;; Make a circle of turtles
  create-turtles Num-Agents
  layout-circle sort turtles  (radius )

while [not success?]
[  ;; create links
  ask links [die]
  ask turtles [
    ;; each pair of turtles is only considered once
  create-links-with turtles with [self > myself and
                                  random-float 1.0 < Connection-Probability]
              ]

;  nw:generate-random turtles links Num-Agents Connection-Probability
;  nw:set-context turtles links
  set success? do-calculations
]
 ;ask links [set color gray]
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Barabasi ;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to Create-Barabasi 
set success? true
  ;; Make a circle of turtles
create-turtles Num-Agents
layout-circle sort turtles  (radius )

while [not success?]
[  ;; create links
ask links [die]
nw:generate-preferential-attachment turtles links Num-Agents
nw:set-context turtles links
set success? do-calculations
]

;ask links [set color gray]

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Small World  ;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to Create-Small-World ;; taken from the netlogo library
create-turtles Num-Agents
layout-circle sort turtles (radius )
wire-rewire-them
end

to wire-them
ask links [die]
 let n 0
  while [n < Num-Agents]
  [;; make edges with the next "Initial-Neighbours"
  let i 1
  while [i <= ceiling ( Initial-Neighbours / 2 ) ]
  [
    ask turtle n [create-link-with turtle ((n + i) mod Num-Agents)
                  [set rewired? false]
                  ]
    set i i + 1
  ]
 set n (n + 1)
 ]
end

to wire-rewire-them

  ;; set up a variable to see if the network is connected
  set success? false

  ;; if we end up with a disconnected network, keep trying
  while [not success?] [
    ;; kill the old lattice, reset neighbors, and create new lattice    
    wire-them
    ask links [
      ;; whether to rewire it or not?
      if (random-float 1) < Rewiring-Probability
      [
        ;; "a" remains the same
        let node1 end1
        ;; if "a" is not connected to everybody
        if [ count link-neighbors ] of end1 < ( Num-Agents - 1)
        [
          ;; find a node distinct from node1 and not already a neighbor of node1
          let node2 one-of turtles with [ (self != node1) and (not link-neighbor? node1) ]
          ;; wire the new edge
          ask node1 [ create-link-with node2 [ set rewired? true ] ]
        set rewired? true
        ]
      ]
      
      ;; remove the old edge
      if (rewired?)
      [
        die
      ]
    ]
    ;; check to see if the new network is connected and calculate path length and clustering
    ;; coefficient at the same time
    nw:set-context turtles links
    set success? do-calculations
  
  ]
;ask links [set color gray]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Scale Free  ;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to Create-Scale-Free
set graphical? false
setup-sf-parameters
set success? false
let connected? false 

create-turtles Num-Agents [
  set xcor random-xcor
  set ycor random-ycor
  set degree infinity * (-1)
  ;layout-circle sort turtles (max-pxcor - 1)
  ]
let trials 1 
while [not success?] ;tells us if created network is connected
[
show "constructing"
while [not connected?] ;tells us if sequence has the potential to create a connected network 
[
while [not graphical?] ; verify if created sequence is graphical
[
create-degree-sequence
set graphical? verify-graphicality sequence Num-Agents
show "sequence"
]

if-else sum sequence >= 2 * (Num-Agents - 1) [set connected? true]
                                             [set graphical? false]
]
configuration-model ;construct network
;havel-hakimi
nw:set-context turtles links
set success? do-calculations ;is it connected?
if success? = false [set trials trials + 1 ] ;try again to make it connected

if trials > 30      [set success? false ;if sufficient trials, start again
                     set graphical? false  
                     set connected? false                              
                     set trials 1
                    ]
;ask links [set color gray]
]
end

to assign-degrees-to-turtles [degree-sequence]
let i 0
foreach degree-sequence
[
ask item i (sort turtles)
 [
   set degree ?
   set free-stubs ?
 ]
set i ( i + 1)
]
end

to Havel-Hakimi ;;Havel Hakimi procedure constructs a graph from degree sequence, only produces a subset of all possible graphs with given sequence
let free-turtles turtles with [free-stubs > 0]
while [any? free-turtles]
[
set free-turtles turtles with [free-stubs > 0]
let current-turtle max-one-of free-turtles [free-stubs]
let forbiden-turtles [link-neighbors] of current-turtle
ask current-turtle [set free-turtles other free-turtles with [not (member? self forbiden-turtles)]]

while[ [free-stubs] of current-turtle > 0]
[
let link-turtle max-one-of free-turtles [free-stubs]
ask current-turtle [create-link-with link-turtle]
ask (turtle-set current-turtle link-turtle) [set free-stubs (free-stubs - 1)]
ask link-turtle [set free-turtles other free-turtles]
]
]
layout-circle turtles radius
end

to configuration-model ;;star constrained graphicality configuration model more efficient, 
                       ;;produces greater variety of graphs. The probability of producing a certain graph can be calculated for ensemble values

assign-degrees-to-turtles sequence
clear-links

let value -1 
let id -1

let residual-sequence sequence
let possible []

let current-turtle turtle (position (max residual-sequence) residual-sequence)
let free-turtles turtles with [free-stubs > 0]
let forbiden-turtles [link-neighbors] of current-turtle
let link-turtle one-of turtles

let contradiction? false 

while [any? free-turtles and not contradiction? ]
[
set current-turtle turtle (position (max residual-sequence) residual-sequence)
set forbiden-turtles [link-neighbors] of current-turtle
set free-turtles turtles with [free-stubs > 0]
ask current-turtle [set free-turtles other free-turtles with [ not (member? self forbiden-turtles)]]

while [ [free-stubs] of current-turtle > 0]
[

ifelse (length filter [? > 0] residual-sequence) = 2 
        and 
        (sum residual-sequence = 2)[set link-turtle one-of free-turtles                                   
                                    ]
                                 
                                   [
                                   set possible (possible-connections current-turtle free-turtles residual-sequence)
                                   if-else empty? possible
                                   [set contradiction? true];start construction again. 
                                   [set link-turtle turtle (one-of possible)]
                                   ]

ask current-turtle [create-link-with link-turtle]
ask (turtle-set link-turtle current-turtle) [set free-stubs (free-stubs - 1)]
ask link-turtle [set free-turtles other free-turtles]

set id [who] of current-turtle
set value (item id residual-sequence)
set residual-sequence replace-item id residual-sequence (value - 1) 

set id [who] of link-turtle
set value (item id residual-sequence)
set residual-sequence replace-item id residual-sequence (value - 1) 
]
]
end


to-report possible-connections [current-turtle free-turtles residual-sequence]
let final-list n-values Num-Agents [false]
let candidates []
let subsequence residual-sequence
let value -1
let id -1

foreach sort free-turtles
[
set subsequence residual-sequence

set id [who] of current-turtle
set value (item id residual-sequence)
set subsequence replace-item id subsequence (value - 1)

set id [who] of ?
set value (item id residual-sequence)
set subsequence replace-item id subsequence (value - 1)

set subsequence reverse sort subsequence
set subsequence filter [? > 0 ] subsequence

ifelse length subsequence = 2 and sum subsequence = 2 [set final-list replace-item ([who] of ?) final-list true] 
[
 ifelse item 0 subsequence >= length(subsequence) [set final-list replace-item ([who] of ?) final-list false] 
 [
   set final-list replace-item ([who] of ?) final-list (verify-graphicality subsequence length subsequence)
 ]
]

]

set candidates (positions final-list true)
report candidates
end

to-report positions [a-list value] 
  let ids n-values (length a-list) [?] 
  let ids-values map [list ? item ? a-list] ids 
  report map [first ?] filter [item 1 ? = value] ids-values 
end 


to-report verify-graphicality [seq length-sequence]
; k goes from 0 to length sequence - 1
let x_k n-values (length-sequence) [false]
let seqqx n-values (length-sequence) [?]
set seqqx  map [? + 1] seqqx 

let k_star 0
let flag false 

let i (-1)

if-else max seq > (length-sequence - 1) [set flag false]
[if-else (sum seq) mod 2 != 0 [set flag false]
[

;set x_k replace-item 0 x_k length-sequence
while [not flag]
[
;;find position of min index i such that sequence < seqqx(i)
let pos item (i + 1) seqqx
set pos max-position pos seq
set x_k replace-item (i + 1) x_k pos
if item (i + 1) x_k < (i + 1)[set flag true]
set i (i + 1)
]

let j 0
set flag false
while [j < (length x_k ) and not flag]
[
if item j (x_k) < (j + 1) 
[
set k_star j
set flag true 
]
set j (j + 1)
]


let k 0
let L_k item k seq
let R_k (length-sequence - 1)
set flag false 
set k 1

while [not flag and k <= (length-sequence - 1)]
[
;;;show k
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set L_k (L_k + item k seq)

if-else k < k_star
[set R_k (R_k + (item k x_k) - 1)]
[set R_k (R_k + 2 * k - (item k seq))]

if L_k > R_k [set flag true]
set k (k + 1)
]

set flag (not flag)
]]

report flag
end


to-report max-position [number seq]
let count-positions 0
let max-iter (length seq)
let flag false 

while [ count-positions <  max-iter and not flag ]
[
;show count-positions
if-else (item count-positions seq) < number
[set flag true]
[set count-positions (count-positions + 1)]
]
report (count-positions) 
end




to  create-degree-sequence  ;create sequence with sum of degrees even
let parity 1
while [parity mod 2 != 0]
[
;create uniform
set uniform n-values (Num-Agents) [random-float 1]
set sequence []
foreach uniform [set sequence lput (create-one-degree ?) sequence]
set parity sum sequence
]
set sequence (sort sequence)
set sequence (reverse sequence)
end


to-report create-one-degree [R]
let x 0
let S (item x p_k)/ Z
while [S < R]
[
set x (x + 1)
set S (S + ((item x p_k) / Z))
]
report (x + 1)
end

to setup-sf-parameters ;set seq p_k (1, nodes-1,1)^(-g)
set p_k n-values (Num-Agents - 1 ) [?]
set p_k map [? + 1] p_k 
set p_k map [? ^ (- Scale-Free-Exponent)] p_k
set Z sum p_k
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Network Computations ;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Connected Network? and Clustering 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; do-calculations reports true if the network is connected, finds path lengths 

to-report do-calculations
  
  let connected? true  
  
  ;let num-connected-pairs sum [length remove false (remove 0 distance-from-other-turtles)] of turtles
  ;;; In a connected network on N nodes, we should have N(N-1) measurements of distances between pairs,
  ;;; and none of those distances should be infinity.
  ;ifelse ( num-connected-pairs != (Num-Agents * (Num-Agents - 1) ))
  ;[set average-path-length infinity
  ; set connected? false
  ;]
  ;[
  let mean-path-length nw:mean-path-length
  ;]
  ;;find the clustering coefficient and add to the aggregate for all iterations  
  ;; report whether the network is connected or not
if not is-number? mean-path-length [set connected? false]
report connected?
end

;to distancetoturtles
;ask turtles set distance-to-other-turtles [nw:distance-to other turtles]
;end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Path Length?  ;;;;;;;;;;;;;;;;;;;NOT USED ANYMORE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Clustering computations ;;; SUBSTITUTED BY Function in LIBRARY NW::: added a new way of computing (yields different value) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;to find-clustering-coefficient
;  ifelse all? turtles [count link-neighbors <= 1]
;  [
;    set clustering-coefficient 0
;  ]
;  [
;   ask turtles [set node-clustering-coefficient nw:clustering-coefficient]
;   let total 0
;   set total sum [node-clustering-coefficient] of turtles 
;   set clustering-coefficient total / count turtles with [count link-neighbors > 1]
;  ]
;end



;to-report global-clustering-coefficient
;  let closed-triplets sum [ nw:clustering-coefficient * count my-links * (count my-links - 1) ] of turtles
;  let triplets sum [ count my-links * (count my-links - 1) ] of turtles
;  report closed-triplets / triplets
;end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Outputs and Plots ;; ;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
to my-update-plots  
  set-current-plot "Cooperation and Satisfaction"
  set-current-plot-pen "Cooperation" 
  plot cooperation-rate
;  set-current-plot-pen "satisfaction"
;  plot satisfaction-rate
  set-current-plot-pen "Satisfaction"
  plot satisfaction-rate2
;  set-current-plot-pen "Happy and Cooperating"
;  plot count turtles with [shape = "face happy" and cooperate] / Num-Agents
 
 
  set-current-plot "Population"
  set-current-plot-pen "Maxi"
  plot maxi / Num-Agents
  set-current-plot-pen "Mini"
  plot mini / Num-Agents
  set-current-plot-pen "Conf"
  plot conf / Num-Agents
  set-current-plot-pen "Anti"
  plot anti / Num-Agents
  

  set-current-plot "Age Plot"
  set-current-plot-pen "maxi"
  ifelse maxi > 0 [plot mean [age] of turtles with [ my.rule  = 1 ]][plot 0]
  set-current-plot-pen "mini"
  ifelse mini > 0 [plot mean [age] of turtles with [ my.rule  = 2 ]][plot 0]
  set-current-plot-pen "conf"
  ifelse conf > 0 [plot mean [age] of turtles with [ my.rule  = 3 ]][plot 0]
  set-current-plot-pen "anti"
  ifelse anti > 0 [plot mean [age] of turtles with [ my.rule  = 4 ]][plot 0]
  set-current-plot-pen "all"
  plot mean [age] of turtles
 
 
;  set-current-plot "Degrees Plot"
;  set-current-plot-pen "maxi"
;  ifelse maxi > 0 [plot mean [degree] of turtles with [ my.rule  = 1]][plot 0]
;  set-current-plot-pen "mini"
;  ifelse mini > 0 [plot mean [degree] of turtles with [ my.rule  = 2]][plot 0]
;  set-current-plot-pen "conf"
;  ifelse conf > 0 [plot mean [degree] of turtles with [ my.rule  = 3]][plot 0]
;  set-current-plot-pen "anti"
;  ifelse anti > 0 [plot mean [degree] of turtles with [ my.rule  = 4]][plot 0]
  
;  
;  set-current-plot "Clustering Coefficient Plot"
;  set-current-plot-pen "maxi"
;  ifelse maxi > 0 [plot mean [node-clustering-coefficient] of turtles with [ my.rule  = 1]][plot 0]
;  set-current-plot-pen "mini"
;  ifelse mini > 0 [plot mean [node-clustering-coefficient] of turtles with [ my.rule  = 2]][plot 0]
;  set-current-plot-pen "conf"
;  ifelse conf > 0 [plot mean [node-clustering-coefficient] of turtles with [ my.rule  = 3]][plot 0]
;  set-current-plot-pen "anti"
;  ifelse anti > 0 [plot mean [node-clustering-coefficient] of turtles with [ my.rule  = 4]][plot 0]
;  
;  set-current-plot "Page Rank Plot"
;  set-current-plot-pen "maxi"
;  ifelse maxi > 0 [plot mean [page-rank] of turtles with [ my.rule  = 1]][plot 0]
;  set-current-plot-pen "mini"
;  ifelse mini > 0 [plot mean [page-rank] of turtles with [ my.rule  = 2]][plot 0]
;  set-current-plot-pen "conf"
;  ifelse conf > 0 [plot mean [page-rank] of turtles with [ my.rule  = 3]][plot 0]
;  set-current-plot-pen "anti"
;  ifelse anti > 0 [plot mean [page-rank] of turtles with [ my.rule  = 4]][plot 0]
 

   
  end



to establish-color  ;; agent procedure
if-else Colormap-View = "Strategies"
[  if-else my.rule = 1        [set color red]
    [if-else my.rule = 2      [set color green]
      [if-else my.rule = 3    [set color blue]
                           [set color white]]]
]
[
  if-else cooperate [set color blue] [set color orange]
]
end


;to set-final-outputs
;  
;set cooperation-rate count turtles with [cooperate] / Num-Agents
;set satisfaction-rate count turtles with [shape = "face happy"] / Num-Agents
;set satisfaction-rate2  mean [satisfaction2] of turtles
;
;let turtles-maxi turtles with [rule = 1]
;let turtles-mini turtles with [rule = 2]
;let turtles-conf turtles with [rule = 3]
;let turtles-anti turtles with [rule = 4]
;
;
;set maxi count turtles-maxi  
;set mini count turtles-mini  
;set conf count turtles-conf  
;set anti count turtles-anti   
;
;
;if count turtles-maxi > 0
;[
;  set sat-maxi       mean [satisfaction2] of turtles-maxi  
;  set c-maxi         count turtles-maxi with [cooperate] / count turtles-maxi
;  set cg-maxi        count turtles-maxi with [cooperate] / Num-Agents
;  set mean-degree-1  mean [degree] of turtles-maxi  
;  set max-degree-1   max [degree] of turtles-maxi
;  set mean-cc-1      mean [node-clustering-coefficient] of turtles-maxi  
;  set max-cc-1       max [node-clustering-coefficient] of turtles-maxi
;  set mean-bc-1      mean [betweenness-centrality] of turtles-maxi  
;  set max-bc-1       max [betweenness-centrality] of turtles-maxi 
;  set mean-ec-1      mean [eigenvector-centrality] of turtles-maxi  
;  set max-ec-1       max [eigenvector-centrality] of turtles-maxi
;  set mean-pr-1      mean [page-rank] of turtles-maxi  
;  set max-pr-1       max [page-rank] of turtles-maxi 
;  set mean-close-1   mean [closeness-centrality] of turtles-maxi     
;  set max-close-1    max [closeness-centrality] of turtles-maxi  
;  set max-tr-1       max [time.rule] of turtles-maxi  
;  set min-tr-1       min [time.rule] of turtles-maxi  
;  set mean.changes-1 mean [n.changes] of turtles-maxi  
;  
;  if count turtles-maxi > 1
;    [
;      set sd-degree-1    standard-deviation [degree] of turtles-maxi  
;      set sd-cc-1        standard-deviation [node-clustering-coefficient] of turtles-maxi  
;      set sd-bc-1        standard-deviation [betweenness-centrality] of turtles-maxi  
;      set sd-ec-1        standard-deviation [eigenvector-centrality] of turtles-maxi  
;      set sd-pr-1        standard-deviation [page-rank] of turtles-maxi  
;      set sd-close-1    standard-deviation [closeness-centrality] of turtles-maxi  
;      set sd-sat-maxi    standard-deviation [satisfaction2] of turtles-maxi  
;      set sd-changes-1   standard-deviation [n.changes] of turtles-maxi  
;      ]]
;
;
;
;if count turtles-mini > 0
;[
;  set sat-mini       mean [satisfaction2] of turtles-mini  
;  set c-mini         count turtles-mini with [cooperate] / count turtles-mini
;  set cg-mini        count turtles-mini with [cooperate] / Num-Agents
;  set mean-degree-2  mean [degree] of turtles-mini  
;  set max-degree-2   max [degree] of turtles-mini
;  set mean-cc-2      mean [node-clustering-coefficient] of turtles-mini  
;  set max-cc-2       max [node-clustering-coefficient] of turtles-mini
;  set mean-bc-2      mean [betweenness-centrality] of turtles-mini  
;  set max-bc-2       max [betweenness-centrality] of turtles-mini 
;  set mean-ec-2      mean [eigenvector-centrality] of turtles-mini  
;  set max-ec-2       max [eigenvector-centrality] of turtles-mini
;  set mean-pr-2      mean [page-rank] of turtles-mini  
;  set max-pr-2       max [page-rank] of turtles-mini 
;  set mean-close-2   mean [closeness-centrality] of turtles-mini     
;  set max-close-2    max [closeness-centrality] of turtles-mini  
;  set max-tr-2       max [time.rule] of turtles-mini  
;  set min-tr-2       min [time.rule] of turtles-mini  
;  set mean.changes-2 mean [n.changes] of turtles-mini  
;  
;  if count turtles-mini > 1
;    [
;      set sd-degree-2    standard-deviation [degree] of turtles-mini  
;      set sd-cc-2        standard-deviation [node-clustering-coefficient] of turtles-mini  
;      set sd-bc-2        standard-deviation [betweenness-centrality] of turtles-mini  
;      set sd-ec-2        standard-deviation [eigenvector-centrality] of turtles-mini  
;      set sd-pr-2        standard-deviation [page-rank] of turtles-mini  
;      set sd-close-2    standard-deviation [closeness-centrality] of turtles-mini  
;      set sd-sat-mini    standard-deviation [satisfaction2] of turtles-mini  
;      set sd-changes-2   standard-deviation [n.changes] of turtles-mini  
;      ]]
;
;
;
;
;if count turtles-conf > 0
;[
;  set sat-conf       mean [satisfaction2] of turtles-conf  
;  set c-conf         count turtles-conf with [cooperate] / count turtles-conf
;  set cg-conf        count turtles-conf with [cooperate] / Num-Agents
;  set mean-degree-3  mean [degree] of turtles-conf  
;  set max-degree-3   max [degree] of turtles-conf
;  set mean-cc-3      mean [node-clustering-coefficient] of turtles-conf  
;  set max-cc-3       max [node-clustering-coefficient] of turtles-conf
;  set mean-bc-3      mean [betweenness-centrality] of turtles-conf  
;  set max-bc-3       max [betweenness-centrality] of turtles-conf 
;  set mean-ec-3      mean [eigenvector-centrality] of turtles-conf  
;  set max-ec-3       max [eigenvector-centrality] of turtles-conf
;  set mean-pr-3      mean [page-rank] of turtles-conf  
;  set max-pr-3       max [page-rank] of turtles-conf 
;  set mean-close-3   mean [closeness-centrality] of turtles-conf     
;  set max-close-3    max [closeness-centrality] of turtles-conf  
;  set max-tr-3       max [time.rule] of turtles-conf  
;  set min-tr-3       min [time.rule] of turtles-conf  
;  set mean.changes-3 mean [n.changes] of turtles-conf  
;  
;  if count turtles-conf > 1
;    [
;      set sd-degree-3    standard-deviation [degree] of turtles-conf  
;      set sd-cc-3        standard-deviation [node-clustering-coefficient] of turtles-conf  
;      set sd-bc-3        standard-deviation [betweenness-centrality] of turtles-conf  
;      set sd-ec-3        standard-deviation [eigenvector-centrality] of turtles-conf  
;      set sd-pr-3        standard-deviation [page-rank] of turtles-conf  
;      set sd-close-3    standard-deviation [closeness-centrality] of turtles-conf  
;      set sd-sat-conf    standard-deviation [satisfaction2] of turtles-conf  
;      set sd-changes-3   standard-deviation [n.changes] of turtles-conf  
;      ]]
;
;
;if count turtles-anti > 0
;[
;  set sat-anti       mean [satisfaction2] of turtles-anti  
;  set c-anti         count turtles-anti with [cooperate] / count turtles-anti
;  set cg-anti        count turtles-anti with [cooperate] / Num-Agents
;  set mean-degree-4  mean [degree] of turtles-anti  
;  set max-degree-4   max [degree] of turtles-anti
;  set mean-cc-4      mean [node-clustering-coefficient] of turtles-anti  
;  set max-cc-4       max [node-clustering-coefficient] of turtles-anti
;  set mean-bc-4      mean [betweenness-centrality] of turtles-anti  
;  set max-bc-4       max [betweenness-centrality] of turtles-anti 
;  set mean-ec-4      mean [eigenvector-centrality] of turtles-anti  
;  set max-ec-4       max [eigenvector-centrality] of turtles-anti
;  set mean-pr-4      mean [page-rank] of turtles-anti  
;  set max-pr-4       max [page-rank] of turtles-anti 
;  set mean-close-4   mean [closeness-centrality] of turtles-anti     
;  set max-close-4    max [closeness-centrality] of turtles-anti  
;  set max-tr-4       max [time.rule] of turtles-anti  
;  set min-tr-4       min [time.rule] of turtles-anti  
;  set mean.changes-4 mean [n.changes] of turtles-anti  
;  
;  if count turtles-anti > 1
;    [
;      set sd-degree-4    standard-deviation [degree] of turtles-anti  
;      set sd-cc-4        standard-deviation [node-clustering-coefficient] of turtles-anti  
;      set sd-bc-4        standard-deviation [betweenness-centrality] of turtles-anti  
;      set sd-ec-4        standard-deviation [eigenvector-centrality] of turtles-anti  
;      set sd-pr-4        standard-deviation [page-rank] of turtles-anti  
;      set sd-close-4     standard-deviation [closeness-centrality] of turtles-anti  
;      set sd-sat-anti    standard-deviation [satisfaction2] of turtles-anti  
;      set sd-changes-4   standard-deviation [n.changes] of turtles-anti  
;      ]]
;
;
;
;
;
;
;set mean-degree    mean [degree] of turtles  
;set median-degree  median [degree] of turtles
;
;set mean-cc        mean [node-clustering-coefficient] of turtles  
;set median-cc      median [node-clustering-coefficient] of turtles
;
;set mean-bc        mean [betweenness-centrality] of turtles  
;set median-bc      median [betweenness-centrality] of turtles 
;
;set mean-ec        mean [eigenvector-centrality] of turtles  
;set median-ec      median [eigenvector-centrality] of turtles
;
;set mean-pr        mean [page-rank] of turtles  
;set median-pr      median [page-rank] of turtles 
;
;set mean-close     mean [closeness-centrality] of turtles     
;set median-close   median [closeness-centrality] of turtles  
;
;set mean-tr        mean   [time.rule] of turtles    
;set median-tr      median    [time.rule] of turtles    
;
;set mean.changes   mean   [n.changes] of turtles
;set median.changes median [n.changes] of turtles  
;
;
;
;end
;
;
;
;
;
;
;to shuffle-turtles
;set shuffled2? true  ;indicate we're shuffling turtles
;;shuffle
;ask n-of maxi-before-shuffle turtles with [shuffled? = false][
;                                              set my.rule  1
;                                              set shuffled? true 
;                                              ] 
;ask n-of mini-before-shuffle turtles with [shuffled? = false]     [
;                                              set my.rule  2
;                                              set shuffled? true 
;                                              ] 
;ask n-of conf-before-shuffle turtles with [shuffled? = false]     [
;                                              set my.rule  3
;                                              set shuffled? true 
;                                              ] 
;ask n-of anti-before-shuffle turtles with [shuffled? = false]     [
;                                              set my.rule  4
;                                              set shuffled? true 
;                                              ] 
;
;ask turtles [set shuffled? false]
;end
;
;to count-before-shuffle
;set maxi-before-shuffle count turtles with [rule = 1]  
;set mini-before-shuffle count turtles with [rule = 2]  
;set conf-before-shuffle count turtles with [rule = 3]  
;set anti-before-shuffle count turtles with [rule = 4]   
;end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Export ;;;;;;;;;; ;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;create files 


;to create-new-file [prefix]
;set file.name word (word prefix FileName ) ".csv"
;;set-current-directory ""
;end
;
;
;to print-data-in-file
;;; write the information to the file
;let spacer ","
;file-open file.name
;file-print  (list  FileName spacer inicoop  spacer  strength-of-dilemma  spacer  cooperation-rate  spacer  satisfaction-rate  spacer  satisfaction-rate2  spacer
;                      maxi  spacer     mini  spacer  conf  spacer    anti  spacer 
;                      sat-maxi  spacer   sat-mini  spacer   sat-conf  spacer  sat-anti  spacer  
;                      sd-sat-maxi  spacer  sd-sat-mini  spacer  sd-sat-conf  spacer    sd-sat-anti  spacer
;                      c-maxi  spacer     c-mini  spacer     c-conf  spacer     c-anti  spacer   
;                      cg-maxi  spacer     cg-mini  spacer     cg-conf  spacer  cg-anti  spacer 
;                      mean-degree-1  spacer   mean-degree-2  spacer   mean-degree-3  spacer  mean-degree-4  spacer 
;                       sd-degree-1  spacer   sd-degree-2  spacer  sd-degree-3  spacer   sd-degree-4  spacer 
;  mean-cc-1  spacer   mean-cc-2  spacer   mean-cc-3  spacer   mean-cc-4  spacer 
;  sd-cc-1  spacer   sd-cc-2  spacer   sd-cc-3  spacer   sd-cc-4  spacer 
;  mean-bc-1  spacer   mean-bc-2  spacer   mean-bc-3  spacer   mean-bc-4  spacer  
;  sd-bc-1  spacer   sd-bc-2  spacer   sd-bc-3  spacer   sd-bc-4  spacer  
;  mean-ec-1  spacer   mean-ec-2  spacer   mean-ec-3  spacer   mean-ec-4  spacer  
;  sd-ec-1  spacer   sd-ec-2  spacer   sd-ec-3  spacer   sd-ec-4  spacer  
;  mean-pr-1  spacer   mean-pr-2  spacer   mean-pr-3  spacer   mean-pr-4  spacer 
;  sd-pr-1  spacer   sd-pr-2  spacer   sd-pr-3  spacer   sd-pr-4  spacer 
;  mean-close-1  spacer   mean-close-2  spacer   mean-close-3  spacer   mean-close-4  spacer  
;  sd-close-1  spacer   sd-close-2  spacer   sd-close-3  spacer   sd-close-4  spacer
;  max-tr-1  spacer   max-tr-2  spacer   max-tr-3  spacer   max-tr-4   spacer
;  min-tr-1 spacer  min-tr-2 spacer  min-tr-3 spacer  min-tr-4   spacer
;mean.changes-1 spacer  mean.changes-2 spacer  mean.changes-3 spacer  mean.changes-4 spacer  
;sd-changes-1 spacer  sd-changes-2 spacer  sd-changes-3 spacer  sd-changes-4 spacer ticks spacer Rewiring-Probability spacer 
;max-cc-1 spacer  max-bc-1 spacer  max-ec-1 spacer  max-pr-1 spacer  
;max-cc-2 spacer  max-bc-2 spacer  max-ec-2 spacer  max-pr-2 spacer
;max-cc-3 spacer  max-bc-3 spacer   max-ec-3 spacer  max-pr-3 spacer
;max-cc-4 spacer  max-bc-4 spacer   max-ec-4 spacer  max-pr-4 spacer
;max-close-1 spacer max-close-2 spacer max-close-3 spacer max-close-4 spacer 
;mean-degree spacer median-degree  spacer
;mean-cc spacer median-cc spacer
;mean-bc spacer median-bc spacer
;mean-ec spacer median-ec spacer
;mean-pr spacer median-pr spacer
;mean-close spacer median-close spacer
;mean-tr spacer median-tr spacer
;mean.changes spacer median.changes spacer
;shuffled2? spacer repetitions spacer
;Initial-Neighbours spacer Num-Agents spacer diameter spacer network-density spacer average-path-length spacer clustering-coefficient spacer clustering-coefficient-2 spacer n-links 
;spacer equivalent-clustering-coefficient spacer equivalent-clustering-coefficient-2 spacer equivalent-path-length spacer lambdaSW spacer gammaSW spacer Sdelta spacer SWtest spacer omega)
;file-close
;end
;
;


;end
;
;
;to export-ages-test
;set file.name "Initages.csv"
;;set-current-directory ""
;
;let spacer ","
;let l [age] of turtles
;file-open file.name
;file-print   l 
;file-close
;end
;
;to print-ages
;let l [age] of turtles
;show  l
;end


;to export-data
;;;set the directory where the file will be stored
;create-new-file ""
;set-final-outputs
;print-data-in-file
;
;count-before-shuffle
;shuffle-turtles
;set-final-outputs
;print-data-in-file
;end
;
;to export-network
;set-final-outputs
;ask turtles [set neighbors-who  [who] of  turtle-set (sort-on [who] link-neighbors) ]
;ask turtles [set neighbors-type [rule] of turtle-set (sort-on [who] link-neighbors) ]
;
;;;set the directory where the file will be stored
;create-new-file "Network"
;
;let spacer "," 
;foreach sort turtles 
;[
;ask ? [
;      file-open file.name
;      file-print (list  who spacer cooperate    spacer my.rule spacer satisfaction2 spacer
;                        node-clustering-coefficient spacer betweenness-centrality spacer
;                        eigenvector-centrality  spacer page-rank spacer closeness-centrality spacer
;                        longest-path spacer mean-path spacer time.rule spacer time.behavior spacer
;                        n.changes spacer strength-of-dilemma spacer inicoop spacer Rewiring-Probability spacer 
;                        Num-Agents spacer Initial-Neighbours spacer FileName spacer 
;                        clustering-coefficient spacer average-path-length spacer degree spacer n-links spacer 
;                        neighbors-type spacer neighbors-who spacer)
;      file-close
;      ]
;]
;end
;
;
@#$#@#$#@
GRAPHICS-WINDOW
32
27
333
349
-1
-1
2.91
1
10
1
1
1
0
0
0
1
-50
49
-50
49
1
1
1
ticks
30.0

BUTTON
161
371
242
404
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
256
371
333
404
NIL
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

TEXTBOX
25
491
163
577
*Strategies colormap\n\nRed        Maxi\nGreen     Mini\nBlue     Conformist\nWhite      Anti-conf\n                      \n                       
9
0.0
0

SLIDER
402
44
583
77
*-strength-of-dilemma
*-strength-of-dilemma
0
0.5
0
0.01
1
NIL
HORIZONTAL

PLOT
806
10
1114
130
Cooperation and Satisfaction
time
NIL
0.0
500.0
0.0
1.0
true
true
"" ""
PENS
"Cooperation" 1.0 0 -2674135 true "" ""
"Satisfaction" 1.0 0 -13345367 true "" ""

PLOT
807
132
1114
258
Population
time
fraction
0.0
500.0
0.0
1.0
true
true
"" ""
PENS
"Maxi" 1.0 0 -2674135 true "" ""
"Mini" 1.0 0 -13840069 true "" ""
"Conf" 1.0 0 -13345367 true "" ""
"Anti" 1.0 0 -16777216 true "" ""

SLIDER
404
82
579
115
*-inicoop
*-inicoop
0
100
50
1
1
NIL
HORIZONTAL

SLIDER
385
313
586
346
*-Connection-Probability
*-Connection-Probability
0.0
1
0.076
.001
1
NIL
HORIZONTAL

INPUTBOX
496
233
572
293
*-Num-Agents
50
1
0
Number

TEXTBOX
386
207
560
225
*Choose Topology\n
10
15.0
1

CHOOSER
400
234
492
279
*-Topology
*-Topology
"Random" "Small-World" "Scale-Free" "Lattice"
1

TEXTBOX
388
301
598
319
Random Network Connection Probability
9
0.0
1

TEXTBOX
389
351
539
369
Small World Parameters
9
0.0
1

SLIDER
386
398
584
431
*-Rewiring-Probability
*-Rewiring-Probability
0
1
0
.001
1
NIL
HORIZONTAL

SLIDER
386
446
583
479
*-Scale-Free-Exponent
*-Scale-Free-Exponent
1.5
3.1
2
.01
1
NIL
HORIZONTAL

TEXTBOX
391
434
541
452
Scale-Free Exponent
9
0.0
1

TEXTBOX
147
494
255
570
*Behaviour Colormap\n\nBlue   Cooperate\nOrange Defect
9
0.0
1

TEXTBOX
380
28
555
46
*Prisoner's Dilemma Parameters
9
15.0
1

SLIDER
387
362
584
395
*-Initial-Neighbours
*-Initial-Neighbours
1
*-Num-Agents - 1
25
1
1
NIL
HORIZONTAL

CHOOSER
30
372
145
417
Colormap-View
Colormap-View
"Strategies" "Behaviours"
0

MONITOR
683
153
741
198
Maxi %
count turtles with [ my.rule = 1 ] * 100 / count turtles
2
1
11

MONITOR
744
154
802
199
Mini %
count turtles with [my.rule = 2 ] * 100 / count turtles
2
1
11

MONITOR
683
202
743
247
Conf %
count turtles with [my.rule = 3 ]  * 100 / count turtles
2
1
11

MONITOR
744
202
803
247
Anti %
count turtles with [my.rule = 4 ] * 100 / count turtles
2
1
11

MONITOR
23
435
86
480
Mean Path Length
average-path-length
3
1
11

MONITOR
89
436
184
481
Clustering Coefficient
clustering-coefficient
3
1
11

TEXTBOX
47
419
197
437
*Network Properties
9
0.0
1

TEXTBOX
385
128
594
152
*Add noise by replacing the population?
9
15.0
1

SWITCH
620
325
795
358
*-Initial-Random-Types?
*-Initial-Random-Types?
0
1
-1000

TEXTBOX
622
310
792
329
*Random Assignation of Types?
9
0.0
1

INPUTBOX
619
374
704
434
*-Initial-Maxi-%
100
1
0
Number

INPUTBOX
706
374
789
434
*-Initial-Mini-%
0
1
0
Number

INPUTBOX
620
434
703
494
*-Initial-Conf-%
0
1
0
Number

MONITOR
709
436
793
481
Initial-Anti-%
100 - *-Initial-Maxi-% - *-Initial-Mini-% - *-Initial-Conf-%
0
1
11

TEXTBOX
620
360
807
380
Otherwise Input % Initial Types
9
0.0
1

TEXTBOX
723
135
823
158
Types %
9
0.0
1

TEXTBOX
403
221
570
241
*Network Parameters
9
0.0
1

MONITOR
708
23
805
68
Cooperation %
count turtles with [cooperate ] * 100 / count turtles
2
1
11

MONITOR
708
73
804
118
Satisfaction %
mean [satisfaction2] of turtles * 100
2
1
11

MONITOR
187
436
267
481
Density Links
density
2
1
11

PLOT
808
382
1116
502
Clustering Coefficient Plot
Coefficient
Count
0.0
0.05
0.0
1.0
true
true
"" ""
PENS
"maxi" 1.0 0 -2674135 true "" ""
"Mini" 1.0 0 -10899396 true "" ""
"Conf" 1.0 0 -13345367 true "" ""
"Anti" 1.0 0 -16710653 true "" ""

SWITCH
387
509
554
542
Load-Topology
Load-Topology
1
1
-1000

INPUTBOX
437
545
513
605
*-fileIn
NIL
1
0
String

MONITOR
272
436
335
481
Diameter
Diameter
0
1
11

TEXTBOX
389
487
592
518
Load a saved Topology? Specify file:
10
0.0
1

PLOT
808
260
1117
380
Age Plot
Count
Age
0.0
500.0
45.0
70.0
true
true
"" ""
PENS
"maxi" 1.0 0 -2674135 true "" ""
"mini" 1.0 0 -10899396 true "" ""
"conf" 1.0 0 -13345367 true "" ""
"anti" 1.0 0 -16777216 true "" ""
"all" 1.0 0 -2064490 true "" ""

PLOT
808
503
1116
623
Page Rank Plot
Page Rank
Count
0.0
100.0
0.0
0.05
true
true
"" ""
PENS
"maxi" 1.0 0 -2674135 true "" ""
"mini" 1.0 0 -10899396 true "" ""
"conf" 1.0 0 -13345367 true "" ""
"anti" 1.0 0 -16777216 true "" ""

BUTTON
278
494
351
527
Layout
layout
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
277
529
356
562
resize-nodes
resize-nodes
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
407
141
558
174
*-replacement?
*-replacement?
1
1
-1000

MONITOR
630
153
680
198
% New Turtles
count turtles with [shape = \"target\"] * 100 / count turtles
2
1
11

TEXTBOX
639
293
789
311
*Choose types distribution
9
15.0
1

SLIDER
407
175
556
208
*-cultural-constant
*-cultural-constant
.001
20
1
.001
1
NIL
HORIZONTAL

MONITOR
629
202
679
247
Mean Age 
mean [age] of turtles
2
1
11

@#$#@#$#@
## WHAT IS IT?

This is a version of metamimetic games with agents playing the prisoner's dilemma game:

Agents 




                                 Payoff Matrix
                                 -------------
                                    OPPONENT
          BEHAVIORS   Cooperate            Defect
                        -----------------------------
           Cooperate |(1-p, 1-p)            (0, 1)
      YOU            |
           Defect    |(1, 0)                (p, p)
    
            (x, y) = x: your score, y: your partner's score
            Note: higher the score (amount of the benefit), the better.

whit each one of their neighbours in a torus or network   

The agents can have one of 4 valuation functions:
Maxi : The agent tries to maximize the score (payoff)  
mini : The agent tries to minimize the score  
Conformist: The agent tries to behaves as the majority   
Anti-conformist: The agent tries to behave as the minority
   
## HOW TO USE IT

Decide what percentage of patches should cooperate at the initial stage.

Decide the topology structure or load one.

If you are not loading a topology; choose the parameters for the desired topology. Notice the size of the lattice is fixed and you cant change the number of agents.

Also, choose if agents can incur in errors while copying either rules or behaviors, with the corresponding sliders.

Additionaly, choose if agents can have biased perceptions on their own satisfaction with the chooser error_on_satisfaction

Finally choose if agents can do something different than that of what they see in their neighbourhood through the chooser Innovate?

## HOW IT WORKS

At each period: 

Each agent A plays a prisoner's dilemma game pairwise with all of its neighbours. The scores for all the pairwise games played are summed up to become the new payoffs of the agent.  

Each agent looks at the payoffs, decision-making rules and behaviours of other agents in its neighbourhood Gamma_A. 

For any agent A, if according to A's  type (payoffs based or non-materialistic) there is one neighbour B that is more successful than A himself, and if B has a different decision-making rule, then A copies the rule of agent B. In the case of two or more candidates to copy, then A chooses one of the rules at random. 

If according to its new rule of behaviour and its associated utility function, A is still not among the most successful agents in Gamma_A, then A copies the behaviour of the neighbour with the best situation.


As an example:

 If agent A had the conformist type and if the majority of its neighbours have turned to maxi since last round, then A will adopt the maxi rule. Here, the imitation rule is used to update itself (reflexivity).
 If same agent A, which is now a maxi agent, played C last round but a D-player did strictly better than all of A’s neighbours (A included), then A will become a D-player. Here, the imitation rule is used to update the behaviour (metacognition).


Maxi and mini agents want to maximize or minimize their scores and look for those neighbours who did better score-wise. Conformists and anti-conformists desire to be in the majority or the minority respectively.


## THINGS TO NOTICE

Parameters of the network can be observed bellow the world.

How do populations change with the strength of the dilemma?

What are the effects of the different types of noise?

Where are agents located in the network at the attractor? 
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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="SW35" repetitions="5" runMetricsEveryStep="false">
    <go>run-Logo 500</go>
    <final>export-graphL
export-propL
export-agesL
export-coopL</final>
    <exitCondition>if condition or ticks &gt; 500</exitCondition>
    <enumeratedValueSet variable="Colormap-View">
      <value value="&quot;Strategies&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-strength-of-dilemma">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-inicoop">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="*-Rewiring-Probability" first="0" step="0.25" last="1"/>
    <enumeratedValueSet variable="*-Initial-Random-Types?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Num-Agents">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-topology?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Neighbours">
      <value value="12"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Topology">
      <value value="&quot;Small-World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-replacement?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-cultural-constant">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-fileIn">
      <value value="&quot;SWNeighbors&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="LatticeMinisCoop" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>(all? turtles [shape = "face happy"] and ticks &gt; 1) or ticks  &gt; 100</exitCondition>
    <metric>count turtles with [rule = 1] / count turtles</metric>
    <metric>count turtles with [rule = 2] / count turtles</metric>
    <metric>count turtles with [rule = 3] / count turtles</metric>
    <metric>count turtles with [rule = 4] / count turtles</metric>
    <metric>count turtles with [cooperate? = TRUE] / count turtles</metric>
    <metric>count turtles with [rule = 1 and cooperate? = TRUE] / count turtles with [rule = 1]</metric>
    <metric>count turtles with [rule = 2 and cooperate? = TRUE] / count turtles with [rule = 2]</metric>
    <metric>count turtles with [rule = 3 and cooperate? = TRUE] / count turtles with [rule = 3]</metric>
    <metric>count turtles with [rule = 4 and cooperate? = TRUE] / count turtles with [rule = 4]</metric>
    <enumeratedValueSet variable="*-Initial-Random-Types?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Num-Agents">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Topology">
      <value value="&quot;Lattice&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-p-Error-Copy-Rule">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Innovate?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-p-Error-Copy-Behavior">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Colormap-View">
      <value value="&quot;Strategies&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Copy-Thetas?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="error_on_satisfaction">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-topology?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="FileName">
      <value value="&quot;latticeMinisCop.txt&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="*-strength-of-dilemma" first="0" step="0.1" last="0.5"/>
    <steppedValueSet variable="*-inicoop" first="0" step="15" last="100"/>
  </experiment>
  <experiment name="ASW" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>run-Logo 500</go>
    <final>export-graphL
export-coopL
export-propL
export-agesL</final>
    <exitCondition>condition or ticks &gt; 500</exitCondition>
    <enumeratedValueSet variable="Load-Topology">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Colormap-View">
      <value value="&quot;Strategies&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Topology">
      <value value="&quot;Small-World&quot;"/>
    </enumeratedValueSet>
    <steppedValueSet variable="*-Rewiring-Probability" first="0" step="0.025" last="1"/>
    <enumeratedValueSet variable="*-Initial-Neighbours">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-inicoop">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="*-strength-of-dilemma" first="0" step="0.025" last="0.5"/>
    <enumeratedValueSet variable="*-Initial-Random-Types?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Num-Agents">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-fileIn">
      <value value="&quot;&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-cultural-constant">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Scale-Free-Exponent">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Conf-%">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Mini-%">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Maxi-%">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-replacement?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Connection-Probability">
      <value value="0.076"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
VIEW
55
40
385
370
0
0
0
1
1
1
1
1
0
1
1
1
-50
49
-50
49

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
