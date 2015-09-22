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
;lAvg
;condition
;cooperation-list
;avg1 
;avg2  
;var1 
;var2 

;NETWORK CONSTRUCTION
;for scale-free
graphical?
sequence
p_k
Z
uniform
success? ;connectivity

;;appearance 
sizeT
plot.radius

;;OUTPUTS
  cooperation-rate
  satisfaction-rate
  satisfaction-rate2

;Life expectancy , death rates 
life-expectation
mortality-rate
prob-to-die 
prob-die-imitation
infinity



;TURTLE POPULATION
  maxi
  mini
  conf
  anti

  turtles-maxi
  turtles-mini
  turtles-conf
  turtles-anti

;to export stuff
mean.scores
mean.coop
mean.sat
mean.max
mean.min
mean.conf
mean.anti
mean.age.max
mean.age.min
mean.age.conf
mean.age.anti
coop.maxi
coop.mini
coop.conf
coop.anti
sat.maxi
sat.mini
sat.conf
sat.anti
scores.maxi
scores.mini
scores.conf
scores.anti

   
CH.maxi.prop  
CH.mini.prop  
CH.conf.prop  
CH.anti.prop  
CU.maxi.prop  
CU.mini.prop  
CU.conf.prop  
CU.anti.prop  
DH.maxi.prop  
DH.mini.prop  
DH.conf.prop  
DH.anti.prop  
DU.maxi.prop  
DU.mini.prop  
DU.conf.prop  
DU.anti.prop  
CH.maxi.sat   
CH.mini.sat   
CH.conf.sat   
CH.anti.sat   
CU.maxi.sat   
CU.mini.sat   
CU.conf.sat   
CU.anti.sat   
DH.maxi.sat   
DH.mini.sat   
DH.conf.sat   
DH.anti.sat   
DU.maxi.sat   
DU.mini.sat   
DU.conf.sat   
DU.anti.sat   
CH.maxi.scores
CH.mini.scores
CH.conf.scores
CH.anti.scores
CU.maxi.scores
CU.mini.scores
CU.conf.scores
CU.anti.scores
DH.maxi.scores
DH.mini.scores
DH.conf.scores
DH.anti.scores
DU.maxi.scores
DU.mini.scores
DU.conf.scores
DU.anti.scores

maxi-coop-happy  
mini-coop-happy  
conf-coop-happy  
anti-coop-happy  
maxi-coop-UNhappy
mini-coop-UNhappy
conf-coop-UNhappy
anti-coop-UNhappy
maxi-def-happy   
mini-def-happy   
conf-def-happy   
anti-def-happy   
maxi-def-UNhappy 
mini-def-UNhappy 
conf-def-UNhappy 
anti-def-UNhappy 

Binterval
ticks-read 
averages-length

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
myset
Ibest
  rule?
  behavior?
my.best.elements
;come from R

;globalInfo       
FILEID
FILESIZE
NODEID
SWP
FILENEI
GAMMA
ERP

betwSV
closeSV
degSV
evSV
meanPath
clustSV
powerlaw
diameter
girth
radius
density
assDeg
efficiency
sw
key
alpha.global
authority.global
eccentricity.global
knn.global
pr.global
power.global
gcent.global
lcent.global
scent.global


;nodeInfo


alpha.centr
authority      
eccent         
knn            
pr             
power          
gcent          
lcent          
scent          
clustNV        
constraint     
betwNV         
closeNV        
degNV          
evNV           


;go out to identify on R
filePars

degree
free-stubs

rule.history
behavior.history
satisfaction.history
scores.history
best.history
age.history 

;neighbors' type
n.maxi
n.mini
n.anti
n.conf

;neighbors' type
n.maxi.list
n.mini.list
n.anti.list
n.conf.list

;for outputs
;  theta_1
;  theta_2
;  weighting-history
;  copy-error-rule
;  copy-error-behavior
 
run.info 

my.neighbors
]

links-own[
; for small-world 
 rewired?
  ]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; To Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to go
;;;;;;;;;;;;;;;;;;;;;
;uncomment to change dynamically on widget
set Strength-of-Dilemma *-strength-of-dilemma
set inicoop *-inicoop
set replacement? *-replacement?
set cultural-constant *-cultural-constant
if replacement? [set-life-distribution-USA2010]
;;;;;;;;;;;;;;;;;;;;;
ask turtles [interact]
decision-stage
learn-stage

ask turtles [
establish-color
set-faces
set satisfaction2 satisfaction-2
fill.state.info2
;;;;;;;;;;;;;;;;;;;;;;;
;uncomment to view changes widget
;set-outputs-2
]
set-outputs-1
;;;;;;;;;;;;;;;;;;;;;;
my-update-plots1
;my-update-plots2
ask turtles [set chances.imitations chances.imitations + 1             
             ifelse replacement? [if  chances.imitations >= cultural-constant   [set age age + 1
                                                             set chances.imitations 0]][set age age + 1]]
if replacement? [replacement]
tick
end


to go-automatic2 ;;FOR GRID
ask turtles [interact]
decision-stage
learn-stage

ask turtles [set satisfaction2 satisfaction-2]
if ticks > ticks-read [
set-outputs-1
ask turtles [fill.state.info]            
set-outputs-2
                     ]

ask turtles  [set chances.imitations chances.imitations + 1         
             ifelse replacement? [if  chances.imitations >= cultural-constant   [set age age + 1
                                                                                set chances.imitations 0]][set age age + 1]]
if replacement? [replacement]
tick
end

to go-automatic
ask turtles [interact]
decision-stage
learn-stage
ask turtles [set satisfaction2 satisfaction-2]
if ticks > ticks-read [
                       set-outputs-1
                       ask turtles [fill.state.info]
                       set-outputs-2
                       ]
;;;;;;;;;;;;;;;;;;;;;;;;
;;uncomment to view changes widget
;;ask turtles [establish-color]
;;ask turtles [set-faces]
; my-update-plots1
;;my-update-plots2
;;;;;;;;;;;;;;;;;;;;;;;;
ask turtles  [set chances.imitations chances.imitations + 1             
             ifelse replacement? [if  chances.imitations >= cultural-constant   [set age age + 1
                                                                                 set chances.imitations 0] ][set age age + 1]]
if replacement? [replacement]
tick
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Open Mole Routines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




to run-to-grid [tmax ticks-to-read time-series-output-length averages-N-length]
common-setup
set ticks-read ticks-to-read
set Binterval time-series-output-length
set averages-length averages-N-length
repeat tmax [go-automatic2]
reset-ticks
end 

to run-Logo [tmax ticks-to-read time-series-output-length averages-N-length]
setup   
set ticks-read ticks-to-read
set Binterval time-series-output-length
set averages-length averages-N-length
repeat tmax [go-automatic]
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;              Go Routines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to fill.state.info
set rule.history lput my.rule rule.history
set behavior.history lput cooperate behavior.history 
set satisfaction.history lput satisfaction2 satisfaction.history 
set scores.history lput score scores.history
set best.history lput Ibest best.history 
set age.history lput age age.history 
end

to fill.state.info2
set rule.history remove-item 0 (lput my.rule rule.history)
set behavior.history remove-item 0 (lput cooperate behavior.history) 
set satisfaction.history remove-item 0 (lput satisfaction2 satisfaction.history) 
set scores.history remove-item 0 (lput score scores.history)
set best.history remove-item 0 (lput Ibest best.history )
set age.history remove-item 0 (lput age age.history )
end

;to reset-change
;ask turtles   [
;              set rule? false
;              set behavior? false
;              ]
;end

to set-faces
ifelse am-i-the-best?   [set shape "face happy"]
                        [set shape "face sad"]                          
end

to interact  ;; calculates the agents' payoffs for Prisioner's Dilema.
let total-cooperators count my.neighbors with [cooperate]
set inst.score 0
ifelse cooperate
    [set inst.score (total-cooperators * (1 - Strength-of-Dilemma) / degree)]
    [set inst.score ((total-cooperators + (degree - total-cooperators) * Strength-of-Dilemma ) / degree)]  
set last.score score
set score inst.score
end


to-report am-i-the-best? ;; reports true if the agent is the best in its neighborhood
 let test false  
 if ( my.rule  = 1) and  (score >= [score] of max-one-of my.neighbors [score]  * 0.99)  [set test true]
 if ( my.rule  = 2) and  (score <= [score] of min-one-of my.neighbors [score] * 1.01)     [set test true]
 if ( my.rule  = 3) and  (member? my.rule majority-rules)                                      [set test true]
 if ( my.rule  = 4) and  (member? my.rule minority-rules) and not all? (my.neighbors) [ my.rule  = 4]  [set test true]    
 report test
end

to decision-stage
ask turtles [
  set Ibest am-i-the-best?
  let satisfaction  Ibest ;  
;  if error_on_satisfaction
;  [
;  if random-float 1 <= copy-error-rule ;
;     [set satisfaction not am-i-the-best?]
;  ]
if not satisfaction
[
;if random-float 1 <= theta ;only some agents will be allowed to change rule;      [
      set rule? true 
      set behavior? true  ;      ]
; if random-float 1 <= theta  ;      [set behavior? true]
]

if age < 15 
    [set rule? false]
]
end

to learn-stage
ask turtles 
[
if rule? 
[
select-rule
]
if behavior? [
select-behavior]
]
end


to-report best-elements ;; report a list with the agents with the best performance according to agents  
let bestel myset
  if-else my.rule = 1 [set bestel bestel with [score >= [score] of max-one-of bestel [score] * 0.99]][ 
    
    if-else  my.rule = 2 [set bestel bestel with [score <= [score] of min-one-of bestel [score] * 1.01]][
       
            if-else my.rule = 3 [
                               let rules-list majority-rules
                               set bestel bestel with [member? my.rule rules-list]
                                ] [ 
                                 let rules-list minority-rules
                                 if not empty? rules-list [set bestel bestel with [member? my.rule rules-list]]  
                                  ]
                                                                                                        ]]
report bestel
end  

; choose strategy if your rule is not the best, if innovate? choose rule if you are unsatisfied
to select-rule              
   set my.best.elements best-elements
  ;ifelse not is-my-rule-the-best?   
   if not is-my-rule-the-best?   
   [
   copy-strategy (one-of my.best.elements)
   ]         
   ;[if not am-i-the-best? and member? rule [rule] of best-elements and innovate? ;stuck agent will innovate with probability error-copy
   ;    [set rule (random 4 + 1)]
   ;]
end

to-report is-my-rule-the-best? ;; reports true if the agent's my.rule is used by any of the best valuated agents in its neighborhood (according with its rule) and false otherwise
  let test false
  ifelse Ibest [set test true][
  if member? my.rule [my.rule] of my.best.elements [set test true] 
  ]
  report test
end

to copy-strategy [temp-agent]
;;;RULE STEP
;ifelse random-float 1.0 > copy-error-rule ; some agents do the right thing
;       [
       set my.rule [my.rule] of temp-agent
;      set theta_1 [theta_1] of temp-agent       
;         set theta_2 [theta_2] of temp-agent 
;         if Copy-Thetas? [
;         set theta_1 add-noise "theta_1" Transcription-Error
;         set theta_2 add-noise "theta_2" Transcription-Error                         ];       ]     
;       [set my.rule random 4 + 1 ] ;do a random thing
;       
       set rule? false
end

to select-behavior   
;ifelse random-float 1 > copy-error-behavior ;only some agents do the right thing 
;       [ 
       if-else ( my.rule  = 1) or ( my.rule  = 2) [set cooperate [cooperate] of one-of best-elements ]
             [if-else  my.rule = 3  [set cooperate majority-behavior] [set cooperate not majority-behavior]]
;       ]
;      [
;      ifelse random-float 1.0 < .5  [set cooperate true] [set cooperate false] ;choose random behaviour
;      ]
set behavior? false
end 



to-report satisfaction-2
let sat2 0
 
if-else my.rule = 1 [
            let mmscore min [score] of myset
            let Mscore max [score] of myset
            ifelse abs(Mscore - mmscore) = 0
            [set sat2 1]
            [set sat2  ( (score  - mmscore ) / (Mscore - mmscore))] 
            ]                          
[
if-else my.rule = 2 [
                    let mmscore min [score] of myset
                    let Mscore max [score] of myset
                    ifelse   (Mscore - mmscore) = 0
                    [set sat2 1] 
                    [set sat2  ( ( Mscore - score  ) / ( Mscore - mmscore ))] 
                    ]              
[
if-else my.rule = 3 [
                    let my-frequency ( count my.neighbors with [ my.rule  = 3] + 1 ) / (degree + 1)
                    let Mfrequency max-frequency
                    let mmfrequency min-frequency
                    ifelse abs(mmfrequency - Mfrequency) = 0 [set sat2 1] [set sat2  (my-frequency - mmfrequency) / (Mfrequency - mmfrequency)]
                    ]
                    [
                    let Mfrequency max-frequency
                    let mmfrequency min-frequency
                    let my-frequency (count my.neighbors with [ my.rule  = 4]  + 1) / ( degree + 1)
                    ifelse abs( Mfrequency - mmfrequency ) = 0 [set sat2 1] [set sat2  ( Mfrequency - my-frequency ) / (  Mfrequency - mmfrequency)]
                   ]
]
]
report sat2
end

to-report majority-behavior
  let mylist [cooperate] of myset
  report one-of modes mylist
end



to-report min-frequency
let l item 0 minority-rules
report count (turtle-set my.neighbors self) with [ my.rule  = l] / (degree + 1)
end

to-report max-frequency
let l item 0 majority-rules
report count (turtle-set my.neighbors self) with [ my.rule  = l] / (degree + 1)
end


to-report majority-rules  ;; reports a set with the number of the most frequent rules in agent's neighborhood (agent included)
                          ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist [ my.rule ] of myset
  set mylist modes mylist
  report mylist
end

to-report minority-rules ;; reports a set with the number of the less frequent rules in agent's neighborhood (agent included)
                         ;; be careful when use in an ask cycle as the command is applied to "self"
  let mylist_1 [ my.rule ] of myset
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



to-report add-noise [value noise-std]
      let epsilon random-normal 0.0 noise-std
      if ( epsilon <= -100 )
      [ set epsilon -99] 
      let noisy-value runresult value * 100 / ( 100 + epsilon )
      if (noisy-value > 1) [set noisy-value 1]
      if (noisy-value < 0) [set noisy-value 0]     
      report noisy-value
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
                                 ;Reported ages have an- averages-length of 5 years starting from 0 until 100 years

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
  if random-float 1  < prob-die 
             [
             ;set ticks.at.death.list lput ticks ticks.at.death.list
             replace
             ]
       ]
end   

to replace  
    set shape "target"
    set age 0
    set rule? false
    set behavior? false
    set my.rule (random 4) + 1 
;    set shape "face sad"
;    set size sizeT
    set satisfaction2 1
    ifelse random-float 1.0 < .5 ;(inicoop / 100)
        [set cooperate true]
        [set cooperate false]
    establish-color
    set score 0.0
    set rule? false
    set behavior? false
set chances.imitations 0
set Ibest true
;set shuffled? false
end


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
if not load-topology? [

if Topology = "Random" [set Connection-Probability *-Connection-Probability]

;only setup if SW
if Topology = "Small-World"    [
                               set Initial-Neighbours  *-Initial-Neighbours 
                               set Rewiring-Probability *-Rewiring-Probability
                               ]

if Topology = "Scale-Free" [set Scale-Free-Exponent *-Scale-Free-Exponent]
]


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

set plot.radius ( ( min (list world-width world-height) ) / 2 - 1)  
common-setup
end



to common-setup
set Initial-Anti-% (100 - Initial-Conf-% - Initial-Mini-% - Initial-Maxi-%)
set infinity Num-Agents * 100
set success? false
;set condition false
;set cooperation-list []
;set avg1 0
;set avg2 0 
;set var1 0
;set var2 0
;set lAvg 50

ifelse not load-topology? [setup-Topology] 
[
ifelse (last FileIn) = "t"   [
                                nw:load-matrix FileIn turtles links
                                ask links [set color gray]
                               ]
                               [  
                               ;show FileIn
                               ;show "reading"
                               nw:load-graphml FileIn 
                               nw:set-context turtles links
                               ;show FileIn
                               ]

]



set Num-Agents count turtles
setup-init-turtles

if Topology != "Lattice" [ask turtles [set size 3]]
set sizeT [size] of one-of turtles 

set-life-distribution-USA2010
;if replacement? [
;                 init-age-USA2010
;                ]

ask turtles [set degree count link-neighbors]
set FileOut (word ( remove ".graphml" FileIn ) "_" inicoop "_" Strength-of-Dilemma  "_"  cultural-constant "_" replacement? )
ask turtles [set filePars  FileOut ]


set mean.coop    [] 
set mean.sat     [] 
set mean.scores  [] 
set mean.max     [] 
set mean.min     [] 
set mean.conf    [] 
set mean.anti    [] 
set mean.age.max  [] 
set mean.age.min  [] 
set mean.age.conf [] 
set mean.age.anti [] 

set coop.maxi      []
set coop.mini      []
set coop.conf      []
set coop.anti      []
set sat.maxi       []
set sat.mini       []
set sat.conf       []
set sat.anti       []
set scores.maxi    []
set scores.mini    []
set scores.conf    []
set scores.anti    []
set CH.maxi.prop   []
set CH.mini.prop   []
set CH.conf.prop   []
set CH.anti.prop   []
set CU.maxi.prop   []
set CU.mini.prop   []
set CU.conf.prop   []
set CU.anti.prop   []
set DH.maxi.prop   []
set DH.mini.prop   []
set DH.conf.prop   []
set DH.anti.prop   []
set DU.maxi.prop   []
set DU.mini.prop   []
set DU.conf.prop   []
set DU.anti.prop   []
set CH.maxi.sat    []
set CH.mini.sat    []
set CH.conf.sat    []
set CH.anti.sat    []
set CU.maxi.sat    []
set CU.mini.sat    []
set CU.conf.sat    []
set CU.anti.sat    []
set DH.maxi.sat    []
set DH.mini.sat    []
set DH.conf.sat    []
set DH.anti.sat    []
set DU.maxi.sat    []
set DU.mini.sat    []
set DU.conf.sat    []
set DU.anti.sat    []
set CH.maxi.scores []
set CH.mini.scores []
set CH.conf.scores []
set CH.anti.scores []
set CU.maxi.scores []
set CU.mini.scores []
set CU.conf.scores []
set CU.anti.scores []
set DH.maxi.scores []
set DH.mini.scores []
set DH.conf.scores []
set DH.anti.scores []
set DU.maxi.scores []
set DU.mini.scores []
set DU.conf.scores []
set DU.anti.scores []

reset-ticks
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
     set label ""
;     set size 1
     set age 0
     set satisfaction2 1
     ifelse random-float 1.0 < (inicoop / 100)
        [set cooperate true]
        [set cooperate false]
     establish-color
     set score 0.0
     set rule? false
     set behavior? false


set chances.imitations 0

set run.info (word FILEID "_" "Dilemma" "_" Strength-of-Dilemma  "_"  "inicoop" "_" inicoop  "_" "replace"  "_" replacement?  "_" "cc"  "_" cultural-constant)  
                       
set rule.history (list 0)
set behavior.history  (list 0)
set satisfaction.history  (list 0)
set scores.history  (list 0)
set best.history  (list 0)
set age.history  (list 0)

set n.maxi.list  (list 0)
set n.mini.list  (list 0)
set n.anti.list  (list 0)
set n.conf.list  (list 0)
set my.neighbors link-neighbors
set myset (turtle-set my.neighbors self)
set Ibest true
]
resize-nodes
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Measures ;;;;;;;;;; ;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


to set-outputs-1
  ;populations
set turtles-maxi turtles with [ my.rule  = 1]
set turtles-mini turtles with [ my.rule  = 2]
set turtles-conf turtles with [ my.rule  = 3]
set turtles-anti turtles with [ my.rule  = 4]

set maxi count turtles-maxi  
set mini count turtles-mini  
set conf count turtles-conf  
set anti count turtles-anti   

set cooperation-rate count turtles with [cooperate] / Num-Agents
;set satisfaction-rate count turtles with [shape = "face happy"] / Num-Agents
set satisfaction-rate2  mean [satisfaction2] of turtles


end


to set-outputs-2  
ask turtles [
set n.maxi.list lput count my.neighbors with  [my.rule = 1]  n.maxi.list
set n.mini.list lput count my.neighbors with  [my.rule = 2]  n.mini.list
set n.anti.list lput count my.neighbors with  [my.rule = 3]  n.anti.list
set n.conf.list lput count my.neighbors with  [my.rule = 4]  n.conf.list
]

;intersections
set mean.coop     lput   cooperation-rate        mean.coop
set mean.sat      lput   satisfaction-rate2      mean.sat
set mean.scores   lput   (mean [score] of turtles)  mean.scores

set mean.max      lput   (maxi / Num-Agents)     mean.max
ifelse count turtles-maxi with [age > 15 ] > 0 
[
set mean.age.max  lput   (mean [age] of turtles-maxi with [age > 15])    mean.age.max
set coop.maxi     lput ((count turtles-maxi with [cooperate = TRUE and age > 15]) / count turtles-maxi with [age > 15] ) coop.maxi
set sat.maxi      lput  (mean [satisfaction2] of turtles-maxi with [age > 15])  sat.maxi
set scores.maxi   lput (mean [score] of turtles-maxi with [age > 15])   scores.maxi
]
[
set mean.age.max  lput   -1    mean.age.max
set coop.maxi     lput   -1 coop.maxi
set sat.maxi      lput   -1  sat.maxi
set scores.maxi   lput   -1  scores.maxi
]

set mean.min      lput   (mini / Num-Agents)     mean.min
ifelse count turtles-mini with [age > 15] > 0 
[
set mean.age.min  lput   (mean [age] of turtles-mini with [age > 15])    mean.age.min
set coop.mini lput ((count turtles-mini with [cooperate = TRUE and age > 15]) / count turtles-mini with [age > 15]) coop.mini
set sat.mini  lput  (mean [satisfaction2] of turtles-mini with [age > 15])  sat.mini
set scores.mini    lput (mean [score] of turtles-mini with [age > 15])   scores.mini
]
[
set mean.age.min  lput   -1    mean.age.min
set coop.mini     lput   -1 coop.mini
set sat.mini      lput   -1  sat.mini
set scores.mini   lput   -1   scores.mini
]

set mean.conf     lput   (conf / Num-Agents)     mean.conf
ifelse count turtles-conf with [age > 15] > 0
[
set mean.age.conf lput   (mean [age] of turtles-conf with [age > 15])   mean.age.conf
set coop.conf     lput ((count turtles-conf with [cooperate = TRUE and age > 15]) / count turtles-conf with [age > 15]) coop.conf
set sat.conf      lput  (mean [satisfaction2] of turtles-conf with [age > 15] )  sat.conf
set scores.conf   lput (mean [score] of turtles-conf with [age > 15])   scores.conf
]
[
set mean.age.conf lput   -1  mean.age.conf
set coop.conf     lput   -1  coop.conf
set sat.conf      lput   -1  sat.conf
set scores.conf   lput   -1  scores.conf
]

set mean.anti     lput   (anti / Num-Agents)     mean.anti
ifelse count turtles-anti with [age > 15] > 0
[
set mean.age.anti lput   (mean [age] of turtles-anti with [age > 15])   mean.age.anti
set coop.anti     lput ((count turtles-anti with [cooperate = TRUE and age > 15]) / count turtles-anti with [age > 15] ) coop.anti
set sat.anti      lput  (mean [satisfaction2] of turtles-anti with [age > 15])  sat.anti
set scores.anti   lput (mean [score] of turtles-anti with [age > 15])   scores.anti
]
[
set mean.age.anti lput   -1 mean.age.anti
set coop.anti     lput   -1 coop.anti
set sat.anti      lput   -1 sat.anti
set scores.anti   lput   -1 scores.anti
]



;;;;;;;;;;COOP HAPPY
set maxi-coop-happy    turtles-maxi with [cooperate = TRUE and Ibest = TRUE and age > 15]  
set mini-coop-happy    turtles-mini with [cooperate = TRUE and Ibest = TRUE and age > 15]       
set conf-coop-happy    turtles-conf with [cooperate = TRUE and Ibest = TRUE and age > 15]       
set anti-coop-happy    turtles-anti with [cooperate = TRUE and Ibest = TRUE and age > 15]       

ifelse count maxi-coop-happy > 0
[
set CH.maxi.prop   lput  (count maxi-coop-happy / count turtles-maxi with [age > 15])  CH.maxi.prop
set CH.maxi.sat    lput  (mean [satisfaction2] of maxi-coop-happy) CH.maxi.sat
set CH.maxi.scores lput  (mean [score] of maxi-coop-happy) CH.maxi.scores
]
[
set CH.maxi.prop   lput  -1  CH.maxi.prop
set CH.maxi.sat    lput  -1  CH.maxi.sat
set CH.maxi.scores lput  -1  CH.maxi.scores
]


ifelse count mini-coop-happy > 0
[
set CH.mini.prop   lput  (count mini-coop-happy / count turtles-mini with [age > 15])  CH.mini.prop
set CH.mini.sat    lput  (mean [satisfaction2] of mini-coop-happy) CH.mini.sat
set CH.mini.scores lput  (mean [score] of mini-coop-happy) CH.mini.scores
]
[
set CH.mini.prop   lput  -1  CH.mini.prop
set CH.mini.sat    lput  -1  CH.mini.sat
set CH.mini.scores lput  -1  CH.mini.scores
]


ifelse count conf-coop-happy > 0
[
set CH.conf.prop   lput  (count conf-coop-happy / count turtles-conf with [age > 15])  CH.conf.prop
set CH.conf.sat    lput  (mean [satisfaction2] of conf-coop-happy) CH.conf.sat
set CH.conf.scores lput  (mean [score] of conf-coop-happy) CH.conf.scores
]
[
set CH.conf.prop   lput  -1  CH.conf.prop
set CH.conf.sat    lput  -1  CH.conf.sat
set CH.conf.scores lput  -1  CH.conf.scores
]


ifelse count anti-coop-happy > 0
[
set CH.anti.prop   lput  (count anti-coop-happy / count turtles-anti with [age > 15])  CH.anti.prop
set CH.anti.sat    lput  (mean [satisfaction2] of anti-coop-happy) CH.anti.sat
set CH.anti.scores lput  (mean [score] of anti-coop-happy) CH.anti.scores
]
[
set CH.anti.prop   lput  -1  CH.anti.prop
set CH.anti.sat    lput  -1  CH.anti.sat
set CH.anti.scores lput  -1  CH.anti.scores
]

;;;;;;;;;;COOP UNHAPPY

set maxi-coop-UNhappy  turtles-maxi with [cooperate = TRUE and Ibest = FALSE and age > 15]      
set mini-coop-UNhappy  turtles-mini with [cooperate = TRUE and Ibest = FALSE and age > 15]      
set conf-coop-UNhappy  turtles-conf with [cooperate = TRUE and Ibest = FALSE and age > 15]      
set anti-coop-UNhappy  turtles-anti with [cooperate = TRUE and Ibest = FALSE and age > 15]      


ifelse count maxi-coop-UNhappy > 0
[
set CU.maxi.prop   lput  (count maxi-coop-UNhappy / count turtles-maxi with [age > 15])  CU.maxi.prop
set CU.maxi.sat    lput  (mean [satisfaction2] of maxi-coop-UNhappy) CU.maxi.sat
set CU.maxi.scores lput  (mean [score] of maxi-coop-UNhappy) CU.maxi.scores
]
[
set CU.maxi.prop   lput  -1  CU.maxi.prop
set CU.maxi.sat    lput  -1  CU.maxi.sat
set CU.maxi.scores lput  -1  CU.maxi.scores
]


ifelse count mini-coop-UNhappy > 0
[
set CU.mini.prop   lput  (count mini-coop-UNhappy / count turtles-mini with [age > 15])  CU.mini.prop
set CU.mini.sat    lput  (mean [satisfaction2] of mini-coop-UNhappy) CU.mini.sat
set CU.mini.scores lput  (mean [score] of mini-coop-UNhappy) CU.mini.scores
]
[
set CU.mini.prop   lput  -1  CU.mini.prop
set CU.mini.sat    lput  -1  CU.mini.sat
set CU.mini.scores lput  -1  CU.mini.scores
]


ifelse count conf-coop-UNhappy > 0
[
set CU.conf.prop   lput  (count conf-coop-UNhappy / count turtles-conf with [age > 15])  CU.conf.prop
set CU.conf.sat    lput  (mean [satisfaction2] of conf-coop-UNhappy) CU.conf.sat
set CU.conf.scores lput  (mean [score] of conf-coop-UNhappy) CU.conf.scores
]
[
set CU.conf.prop   lput  -1  CU.conf.prop
set CU.conf.sat    lput  -1  CU.conf.sat
set CU.conf.scores lput  -1  CU.conf.scores
]


ifelse count anti-coop-UNhappy > 0
[
set CU.anti.prop   lput  (count anti-coop-UNhappy / count turtles-anti with [age > 15])  CU.anti.prop
set CU.anti.sat    lput  (mean [satisfaction2] of anti-coop-UNhappy) CU.anti.sat
set CU.anti.scores lput  (mean [score] of anti-coop-UNhappy) CU.anti.scores
]
[
set CU.anti.prop   lput  -1  CU.anti.prop
set CU.anti.sat    lput  -1  CU.anti.sat
set CU.anti.scores lput  -1  CU.anti.scores
]


;;;;;;;;;;;;;DEFECTING HAPPY
set maxi-def-happy     turtles-maxi with [cooperate = FALSE and Ibest = TRUE and age > 15]      
set mini-def-happy     turtles-mini with [cooperate = FALSE and Ibest = TRUE and age > 15]      
set conf-def-happy     turtles-conf with [cooperate = FALSE and Ibest = TRUE and age > 15]      
set anti-def-happy     turtles-anti with [cooperate = FALSE and Ibest = TRUE and age > 15]      


ifelse count maxi-def-happy > 0
[
set DH.maxi.prop   lput  (count maxi-def-happy / count turtles-maxi with [age > 15])  DH.maxi.prop
set DH.maxi.sat    lput  (mean [satisfaction2] of maxi-def-happy) DH.maxi.sat
set DH.maxi.scores lput  (mean [score] of maxi-def-happy) DH.maxi.scores
]
[
set DH.maxi.prop   lput  -1  DH.maxi.prop
set DH.maxi.sat    lput  -1  DH.maxi.sat
set DH.maxi.scores lput  -1  DH.maxi.scores
]


ifelse count mini-def-happy > 0
[
set DH.mini.prop   lput  (count mini-def-happy / count turtles-mini with [age > 15])  DH.mini.prop
set DH.mini.sat    lput  (mean [satisfaction2] of mini-def-happy) DH.mini.sat
set DH.mini.scores lput  (mean [score] of mini-def-happy) DH.mini.scores
]
[
set DH.mini.prop   lput  -1  DH.mini.prop
set DH.mini.sat    lput  -1  DH.mini.sat
set DH.mini.scores lput  -1  DH.mini.scores
]


ifelse count conf-def-happy > 0
[
set DH.conf.prop   lput  (count conf-def-happy / count turtles-conf with [age > 15])  DH.conf.prop
set DH.conf.sat    lput  (mean [satisfaction2] of conf-def-happy) DH.conf.sat
set DH.conf.scores lput  (mean [score] of conf-def-happy) DH.conf.scores
]
[
set DH.conf.prop   lput  -1  DH.conf.prop
set DH.conf.sat    lput  -1  DH.conf.sat
set DH.conf.scores lput  -1  DH.conf.scores
]


ifelse count anti-def-happy > 0
[
set DH.anti.prop   lput  (count anti-def-happy / count turtles-anti with [age > 15])  DH.anti.prop
set DH.anti.sat    lput  (mean [satisfaction2] of anti-def-happy) DH.anti.sat
set DH.anti.scores lput  (mean [score] of anti-def-happy) DH.anti.scores
]
[
set DH.anti.prop   lput -1  DH.anti.prop
set DH.anti.sat    lput -1  DH.anti.sat
set DH.anti.scores lput -1  DH.anti.scores
]

;;;;;;;;;;;;;DEFECTING UNHAPPY
set maxi-def-UNhappy   turtles-maxi with [cooperate = FALSE and Ibest = FALSE and age > 15]     
set mini-def-UNhappy   turtles-mini with [cooperate = FALSE and Ibest = FALSE and age > 15]     
set conf-def-UNhappy   turtles-conf with [cooperate = FALSE and Ibest = FALSE and age > 15]     
set anti-def-UNhappy   turtles-anti with [cooperate = FALSE and Ibest = FALSE and age > 15]   



ifelse count maxi-def-UNhappy > 0
[
set DU.maxi.prop   lput  (count maxi-def-UNhappy / count turtles-maxi with [age > 15])  DU.maxi.prop
set DU.maxi.sat    lput  (mean [satisfaction2] of maxi-def-UNhappy) DU.maxi.sat
set DU.maxi.scores lput  (mean [score] of maxi-def-UNhappy) DU.maxi.scores
]
[
set DU.maxi.prop   lput -1  DU.maxi.prop
set DU.maxi.sat    lput -1  DU.maxi.sat
set DU.maxi.scores lput -1  DU.maxi.scores
]


ifelse count mini-def-UNhappy > 0
[
set DU.mini.prop   lput  (count mini-def-UNhappy / count turtles-mini with [age > 15])  DU.mini.prop
set DU.mini.sat    lput  (mean [satisfaction2] of mini-def-UNhappy) DU.mini.sat
set DU.mini.scores lput  (mean [score] of mini-def-UNhappy) DU.mini.scores
]
[
set DU.mini.prop   lput -1  DU.mini.prop
set DU.mini.sat    lput -1  DU.mini.sat
set DU.mini.scores lput -1  DU.mini.scores
]


ifelse count conf-def-UNhappy > 0
[
set DU.conf.prop   lput  (count conf-def-UNhappy / count turtles-conf with [age > 15])  DU.conf.prop
set DU.conf.sat    lput  (mean [satisfaction2] of conf-def-UNhappy) DU.conf.sat
set DU.conf.scores lput  (mean [score] of conf-def-UNhappy) DU.conf.scores
]
[
set DU.conf.prop   lput -1  DU.conf.prop
set DU.conf.sat    lput -1  DU.conf.sat
set DU.conf.scores lput -1  DU.conf.scores
]


ifelse count anti-def-UNhappy > 0
[
set DU.anti.prop   lput  (count anti-def-UNhappy / count turtles-anti with [age > 15])  DU.anti.prop
set DU.anti.sat    lput  (mean [satisfaction2] of anti-def-UNhappy) DU.anti.sat
set DU.anti.scores lput  (mean [score] of anti-def-UNhappy) DU.anti.scores
]
[
set DU.anti.prop   lput -1  DU.anti.prop
set DU.anti.sat    lput -1  DU.anti.sat
set DU.anti.scores lput -1  DU.anti.scores
]

end

to export-graph
;nw:save-graphml (word "nl_" Strength-of-Dilemma "_" inicoop "_" cultural-constant "_"
; ( remove ".graphml" FileIn ) ".graphml")
nw:save-graphml "graph.graphml" 
end 


to export-rules
let file.name "Rules.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist rule.history (p - Binterval) (p - 1 ) ) )
      file-close
      ]
]
end



to export-behavior
let file.name "Behavior.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist behavior.history (p - Binterval) (p - 1) ) )
     file-close
      ]
]
end

to export-satisfaction
let file.name "Satisfaction.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist satisfaction.history (p - Binterval) (p - 1) ) )
     file-close
      ]
]
end

to export-scores
let file.name "Scores.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist scores.history (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-best
let file.name "Best.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist best.history (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-age
let file.name "Ages.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist age.history (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-prop1
let file.name "Maxi.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.maxi.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-prop2
let file.name "Mini.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.mini.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end


to export-prop3
let file.name "Conf.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.conf.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end


to export-prop4
let file.name "Anti.csv"
let spacer ","
let l sort-on [NODEID] turtles
let p length [rule.history] of turtle 1 
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.anti.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end


to export-global
let file.name "Global.csv"
let spacer ","
let info [run.info] of turtle 1
let lista1    []
let lista2    []
let lista3    []
let lista4    []
let lista5    []
let lista6    []
let lista7    []
let lista8    []
let lista9    []
let lista10   []
let lista11   []
let lista12   []
let lista13  []
let lista14  []
let lista15  []
let lista16  []
let lista17  []
let lista18  []
let lista19  []
let lista20  []
let lista21  []
let lista22  []
let lista23  []
let lista24  []
let lista25  []
let lista26  []
let lista27  []
let lista28  []
let lista29  []
let lista30  []
let lista31  []
let lista32  []
let lista33  []
let lista34  []
let lista35  []
let lista36  []
let lista37  []
let lista38  []
let lista39  []
let lista40  []
let lista41  []
let lista42  []
let lista43  []
let lista44  []
let lista45  []
let lista46  []
let lista47  []
let lista48  []
let lista49  []
let lista50  []
let lista51  []
let lista52  []
let lista53  []
let lista54  []
let lista55  []
let lista56  []
let lista57  []
let lista58  []
let lista59  []
let lista60  []
let lista61  []
let lista62  []
let lista63  []
let lista64  []
let lista65  []
let lista66  []
let lista67  []
let lista68  []
let lista69  []
let  lista1b  []       
let  lista2b  []       
let  lista3b  []       
let  lista4b  []       
let  lista5b  []       
let  lista6b  []       
let  lista7b  []       
let  lista8b  []       
let  lista9b  []       
let  lista10b  []      
let  lista11b  []      
let  lista12b  []      
 let lista13b  []      
 let lista14b  []      
 let lista15b  []      
 let lista16b  []      
 let lista17b  []      
 let lista18b  []      
 let lista19b  []      
 let lista20b  []      
 let lista21b  []      
 let lista22b  []      
 let lista23b  []      
 let lista24b  []      
 let lista25b  []      
 let lista26b  []      
 let lista27b  []      
 let lista28b  []      
 let lista29b  []      
 let lista30b  []      
 let lista31b  []      
 let lista32b  []      
 let lista33b  []      
 let lista34b  []      
 let lista35b  []      
 let lista36b  []      
 let lista37b  []      
 let lista38b  []      
 let lista39b  []      
 let lista40b  []      
 let lista41b  []      
 let lista42b  []      
 let lista43b  []      
 let lista44b  []      
 let lista45b  []      
 let lista46b  []      
 let lista47b  []      
 let lista48b  []      
 let lista49b  []      
 let lista50b  []      
 let lista51b  []      
 let lista52b  []      
 let lista53b  []      
 let lista54b  []      
 let lista55b  []      
 let lista56b  []      
 let lista57b  []      
 let lista58b  []      
 let lista59b  []      
 let lista60b  []      
 let lista61b  []      
 let lista62b  []      
 let lista63b  []      
 let lista64b  []      
 let lista65b  []      
 let lista66b  []      
 let lista67b  []      
 let lista68b  []      
 let lista69b  []      

let p length [rule.history] of turtle 1 

let lista filter [? > -1] (sublist mean.max       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista1 "NA"] [set lista1 mean lista]
ifelse length lista < 2 [set lista1b "NA"] [set lista1b sqrt variance lista]

set lista filter [? > -1] (sublist mean.min       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista2 "NA" ][set lista2 mean lista]
ifelse length lista < 2 [set lista2b "NA" ][set lista2b sqrt variance lista]

set lista filter [? > -1] (sublist mean.conf      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista3 "NA" ][set lista3 mean lista]
ifelse length lista < 2 [set lista3b "NA" ][set lista3b sqrt variance lista]

set lista filter [? > -1] (sublist mean.anti      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista4 "NA" ][set lista4 mean lista]
ifelse length lista < 2 [set lista4b "NA" ][set lista4b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.max   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista5 "NA" ][set lista5 mean lista]
ifelse length lista < 2 [set lista5b "NA" ][set lista5b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.min   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista6 "NA" ][set lista6 mean lista]
ifelse length lista < 2 [set lista6b "NA" ][set lista6b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.conf  (p - averages-length) (p - 1) )
ifelse empty? lista [set lista7 "NA" ][set lista7 mean lista]
ifelse length lista < 2 [set lista7b "NA" ][set lista7b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.anti  (p - averages-length) (p - 1) )
ifelse empty? lista [set lista8 "NA" ][set lista8 mean lista]
ifelse length lista < 2 [set lista8b "NA" ][set lista8b sqrt variance lista]

set lista filter [? > -1] (sublist coop.maxi      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista9 "NA" ][set lista9 mean lista]
ifelse length lista < 2 [set lista9b "NA" ][set lista9b sqrt variance lista]

set lista filter [? > -1] (sublist coop.mini      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista10 "NA" ][set lista10 mean lista]
ifelse length lista < 2 [set lista10b "NA" ][set lista10b sqrt variance lista]

set lista filter [? > -1] (sublist coop.conf      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista11 "NA" ][set lista11 mean lista]
ifelse length lista < 2 [set lista11b "NA" ][set lista11b sqrt variance lista]

set lista filter [? > -1] (sublist coop.anti      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista12 "NA" ][set lista12 mean lista]
ifelse length lista < 2 [set lista12b "NA" ][set lista12b sqrt variance lista]

set lista filter [? > -1] (sublist sat.maxi       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista13 "NA" ][set lista13 mean lista]
ifelse length lista < 2 [set lista13b "NA" ][set lista13b sqrt variance lista]

set lista filter [? > -1] (sublist mean.sat       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista14 "NA" ][set lista14 mean lista]
ifelse length lista < 2 [set lista14b "NA" ][set lista14b sqrt variance lista]

set lista filter [? > -1] (sublist sat.mini       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista15 "NA" ][set lista15 mean lista]
ifelse length lista < 2 [set lista15b "NA" ][set lista15b sqrt variance lista]

set lista filter [? > -1] (sublist sat.conf       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista16 "NA" ][set lista16 mean lista]
ifelse length lista < 2 [set lista16b "NA" ][set lista16b sqrt variance lista]

set lista filter [? > -1] (sublist sat.anti       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista17 "NA" ][set lista17 mean lista]
ifelse length lista < 2 [set lista17b "NA" ][set lista17b sqrt variance lista]

set lista filter [? > -1] (sublist scores.maxi    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista18 "NA" ][set lista18 mean lista]
ifelse length lista < 2 [set lista18b "NA" ][set lista18b sqrt variance lista]

set lista filter [? > -1] (sublist scores.mini    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista19 "NA" ][set lista19 mean lista]
ifelse length lista < 2 [set lista19b "NA" ][set lista19b sqrt variance lista]

set lista filter [? > -1] (sublist scores.conf    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista20 "NA" ][set lista20 mean lista]
ifelse length lista < 2[set lista20b "NA" ][set lista20b sqrt variance lista]

set lista filter [? > -1] (sublist scores.anti    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista21 "NA" ][set lista21 mean lista]
ifelse length lista < 2[set lista21b "NA" ][set lista21b sqrt variance lista]

set lista filter [? > -1] (sublist CH.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista22 "NA" ][set lista22 mean lista]
ifelse length lista < 2[set lista22b "NA" ][set lista22b sqrt variance lista]

set lista filter [? > -1] (sublist CH.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista23 "NA" ][set lista23 mean lista]
ifelse length lista < 2[set lista23b "NA" ][set lista23b sqrt variance lista]

set lista filter [? > -1] (sublist CH.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista24 "NA" ][set lista24 mean lista]
ifelse length lista < 2[set lista24b "NA" ][set lista24b sqrt variance lista]

set lista filter [? > -1] (sublist CH.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista25 "NA" ][set lista25 mean lista]
ifelse length lista < 2[set lista25b "NA" ][set lista25b sqrt variance lista]

set lista filter [? > -1] (sublist CU.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista26 "NA" ][set lista26 mean lista]
ifelse length lista < 2[set lista26b "NA" ][set lista26b sqrt variance lista]

set lista filter [? > -1] (sublist CU.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista27 "NA" ][set lista27 mean lista]
ifelse length lista < 2[set lista27b "NA" ][set lista27b sqrt variance lista]

set lista filter [? > -1] (sublist CU.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista28 "NA" ][set lista28 mean lista]
ifelse length lista < 2[set lista28b "NA" ][set lista28b sqrt variance lista]

set lista filter [? > -1] (sublist CU.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista29 "NA" ][set lista29 mean lista]
ifelse length lista < 2[set lista29b "NA" ][set lista29b sqrt variance lista]

set lista filter [? > -1] (sublist DH.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista30 "NA" ][set lista30 mean lista]
ifelse length lista < 2[set lista30b "NA" ][set lista30b sqrt variance lista]

set lista filter [? > -1] (sublist DH.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista31 "NA" ][set lista31 mean lista]
ifelse length lista < 2[set lista31b "NA" ][set lista31b sqrt variance lista]

set lista filter [? > -1] (sublist DH.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista32 "NA" ][set lista32 mean lista]
ifelse length lista < 2[set lista32b "NA" ][set lista32b sqrt variance lista]

set lista filter [? > -1] (sublist DH.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista33 "NA" ][set lista33 mean lista]
ifelse length lista < 2[set lista33b "NA" ][set lista33b sqrt variance lista]

set lista filter [? > -1] (sublist DU.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista34 "NA" ][set lista34 mean lista]
ifelse length lista < 2[set lista34b "NA" ][set lista34b sqrt variance lista]

set lista filter [? > -1] (sublist DU.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista35 "NA" ][set lista35 mean lista]
ifelse length lista < 2[set lista35b "NA" ][set lista35b sqrt variance lista]

set lista filter [? > -1] (sublist DU.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista36 "NA" ][set lista36 mean lista]
ifelse length lista < 2[set lista36b "NA" ][set lista36b sqrt variance lista]

set lista filter [? > -1] (sublist DU.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista37 "NA" ][set lista37 mean lista]
ifelse length lista < 2[set lista37b "NA" ][set lista37b sqrt variance lista]

set lista filter [? > -1] (sublist CH.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista38 "NA" ][set lista38 mean lista]
ifelse length lista < 2[set lista38b "NA" ][set lista38b sqrt variance lista]

set lista filter [? > -1] (sublist CH.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista39 "NA" ][set lista39 mean lista]
ifelse length lista < 2[set lista39b "NA" ][set lista39b sqrt variance lista]

set lista filter [? > -1] (sublist CH.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista40 "NA" ][set lista40 mean lista]
ifelse length lista < 2[set lista40b "NA" ][set lista40b sqrt variance lista]

set lista filter [? > -1] (sublist CH.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista41 "NA" ][set lista41 mean lista]
ifelse length lista < 2[set lista41b "NA" ][set lista41b sqrt variance lista]

set lista filter [? > -1] (sublist CU.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista42 "NA" ][set lista42 mean lista]
ifelse length lista < 2[set lista42b "NA" ][set lista42b sqrt variance lista]

set lista filter [? > -1] (sublist CU.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista43 "NA" ][set lista43 mean lista]
ifelse length lista < 2[set lista43b "NA" ][set lista43b sqrt variance lista]

set lista filter [? > -1] (sublist CU.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista44 "NA" ][set lista44 mean lista]
ifelse length lista < 2[set lista44b "NA" ][set lista44b sqrt variance lista]

set lista filter [? > -1] (sublist CU.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista45 "NA" ][set lista45 mean lista]
ifelse length lista < 2[set lista45b "NA" ][set lista45b sqrt variance lista]

set lista filter [? > -1] (sublist DH.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista46 "NA" ][set lista46 mean lista]
ifelse length lista < 2[set lista46b "NA" ][set lista46b sqrt variance lista]

set lista filter [? > -1] (sublist DH.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista47 "NA" ][set lista47 mean lista]
ifelse length lista < 2[set lista47b "NA" ][set lista47b sqrt variance lista]

set lista filter [? > -1] (sublist DH.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista48 "NA" ][set lista48 mean lista]
ifelse length lista < 2[set lista48b "NA" ][set lista48b sqrt variance lista]

set lista filter [? > -1] (sublist DH.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista49 "NA" ][set lista49 mean lista]
ifelse length lista < 2[set lista49b "NA" ][set lista49b sqrt variance lista]

set lista filter [? > -1] (sublist DU.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista50 "NA" ][set lista50 mean lista]
ifelse length lista < 2[set lista50b "NA" ][set lista50b sqrt variance lista]

set lista filter [? > -1] (sublist DU.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista51 "NA" ][set lista51 mean lista]
ifelse length lista < 2[set lista51b "NA" ][set lista51b sqrt variance lista]

set lista filter [? > -1] (sublist DU.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista52 "NA" ][set lista52 mean lista]
ifelse length lista < 2[set lista52b "NA" ][set lista52b sqrt variance lista]

set lista filter [? > -1] (sublist DU.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista53 "NA" ][set lista53 mean lista]
ifelse length lista < 2[set lista53b "NA" ][set lista53b sqrt variance lista]

set lista filter [? > -1] (sublist CH.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista54 "NA" ][set lista54 mean lista]
ifelse length lista < 2[set lista54b "NA" ][set lista54b sqrt variance lista]

set lista filter [? > -1] (sublist CH.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista55 "NA" ][set lista55 mean lista]
ifelse length lista < 2[set lista55b "NA" ][set lista55b sqrt variance lista]

set lista filter [? > -1] (sublist CH.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista56 "NA" ][set lista56 mean lista]
ifelse length lista < 2[set lista56b "NA" ][set lista56b sqrt variance lista]

set lista filter [? > -1] (sublist CH.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista57 "NA" ][set lista57 mean lista]
ifelse length lista < 2[set lista57b "NA" ][set lista57b sqrt variance lista]

set lista filter [? > -1] (sublist CU.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista58 "NA" ][set lista58 mean lista]
ifelse length lista < 2[set lista58b "NA" ][set lista58b sqrt variance lista]

set lista filter [? > -1] (sublist CU.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista59 "NA" ][set lista59 mean lista]
ifelse length lista < 2[set lista59b "NA" ][set lista59b sqrt variance lista]

set lista filter [? > -1] (sublist CU.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista60 "NA" ][set lista60 mean lista]
ifelse length lista < 2[set lista60b "NA" ][set lista60b sqrt variance lista]

set lista filter [? > -1] (sublist CU.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista61 "NA" ][set lista61 mean lista]
ifelse length lista < 2[set lista61b "NA" ][set lista61b sqrt variance lista]

set lista filter [? > -1] (sublist DH.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista62 "NA" ][set lista62 mean lista]
ifelse length lista < 2[set lista62b "NA" ][set lista62b sqrt variance lista]

set lista filter [? > -1] (sublist DH.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista63 "NA" ][set lista63 mean lista]
ifelse length lista < 2[set lista63b "NA" ][set lista63b sqrt variance lista]

set lista filter [? > -1] (sublist DH.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista64 "NA" ][set lista64 mean lista]
ifelse length lista < 2[set lista64b "NA" ][set lista64b sqrt variance lista]

set lista filter [? > -1] (sublist DH.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista65 "NA" ][set lista65 mean lista]
ifelse length lista < 2[set lista65b "NA" ][set lista65b sqrt variance lista]

set lista filter [? > -1] (sublist DU.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista66 "NA" ][set lista66 mean lista]
ifelse length lista < 2[set lista66b "NA" ][set lista66b sqrt variance lista]

set lista filter [? > -1] (sublist DU.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista67 "NA" ][set lista67 mean lista]
ifelse length lista < 2[set lista67b "NA" ][set lista67b sqrt variance lista]

set lista filter [? > -1] (sublist DU.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista68 "NA" ][set lista68 mean lista]
ifelse length lista < 2[set lista68b "NA" ][set lista68b sqrt variance lista]

set lista filter [? > -1] (sublist DU.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista69 "NA" ][set lista69 mean lista]
ifelse length lista < 2[set lista69b "NA" ][set lista69b sqrt variance lista]

file-open file.name
file-print (list  info spacer 
mean (sublist mean.scores    (p - averages-length) (p - 1) ) spacer 
mean (sublist mean.coop      (p - averages-length) (p - 1) ) spacer  
lista1    spacer  lista2    spacer  lista3    spacer lista4    spacer 
lista5    spacer  lista6    spacer  lista7    spacer lista8    spacer 
lista9    spacer  lista10   spacer  lista11   spacer lista12   spacer 
lista13  spacer   lista14  spacer  lista15  spacer  lista16  spacer 
lista17  spacer   lista18  spacer  lista19  spacer  lista20  spacer 
lista21  spacer   lista22  spacer  lista23  spacer  lista24  spacer 
lista25  spacer   lista26  spacer  lista27  spacer  lista28  spacer 
lista29  spacer   lista30  spacer  lista31  spacer  lista32  spacer 
lista33  spacer   lista34  spacer  lista35  spacer  lista36  spacer 
lista37  spacer   lista38  spacer  lista39  spacer  lista40  spacer 
lista41  spacer  lista42  spacer  lista43  spacer  lista44  spacer 
lista45  spacer  lista46  spacer  lista47  spacer  lista48  spacer 
lista49  spacer  lista50  spacer  lista51  spacer  lista52  spacer 
lista53  spacer  lista54  spacer  lista55  spacer  lista56  spacer 
lista57  spacer  lista58  spacer  lista59  spacer  lista60  spacer 
lista61  spacer  lista62  spacer  lista63  spacer  lista64  spacer 
lista65  spacer  lista66  spacer  lista67  spacer  lista68  spacer 
lista69  spacer  sqrt variance (sublist mean.scores    (p - averages-length) (p - 1) ) spacer 
sqrt variance (sublist mean.coop      (p - averages-length) (p - 1) ) spacer  
lista1b    spacer  lista2b    spacer  lista3b    spacer lista4b    spacer 
lista5b    spacer  lista6b    spacer  lista7b    spacer lista8b    spacer 
lista9b    spacer  lista10b   spacer  lista11b   spacer lista12b   spacer 
lista13b  spacer   lista14b  spacer  lista15b spacer  lista16b  spacer 
lista17b  spacer   lista18b  spacer  lista19b  spacer  lista20b  spacer 
lista21b  spacer   lista22b  spacer  lista23b  spacer  lista24b  spacer 
lista25b  spacer   lista26b  spacer  lista27b  spacer  lista28b  spacer 
lista29b  spacer   lista30b  spacer  lista31b  spacer  lista32b  spacer 
lista33b  spacer   lista34b  spacer  lista35b  spacer  lista36b  spacer 
lista37b  spacer   lista38b  spacer  lista39b  spacer  lista40b  spacer 
lista41b  spacer  lista42b  spacer  lista43b  spacer  lista44b  spacer 
lista45b  spacer  lista46b  spacer  lista47b  spacer  lista48b  spacer 
lista49b  spacer  lista50b  spacer  lista51b  spacer  lista52b  spacer 
lista53b  spacer  lista54b  spacer  lista55b  spacer  lista56b  spacer 
lista57b  spacer  lista58b  spacer  lista59b  spacer  lista60b  spacer 
lista61b  spacer  lista62b  spacer  lista63b  spacer  lista64b  spacer 
lista65b  spacer  lista66b  spacer  lista67b  spacer  lista68b  spacer 
lista69b ) 

file-close

end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Outputs and Plots ;; ;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
to my-update-plots1  
  set-current-plot "Cooperation and Satisfaction"
  set-current-plot-pen "Cooperation" 
  plot cooperation-rate
;  set-current-plot-pen "satisfaction"
;  plot satisfaction-rate
  set-current-plot-pen "Satisfaction"
  plot satisfaction-rate2
;  set-current-plot-pen "Happy and Cooperating"
;  plot count turtles with [shape = "face happy" and cooperate] / Num-Agents
set-current-plot-pen "Scores"
  plot mean [score] of turtles 
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
end

to my-update-plots2  

  let maxi-t turtles-maxi with [ cooperate = TRUE]
  let maxi-f turtles-maxi with [ cooperate = FALSE]
  let maxi-h turtles-maxi with [ last best.history  = TRUE]
  let maxi-s turtles-maxi with [ last best.history  = FALSE]
  let maxi-sc turtles-maxi with [ last best.history  = FALSE and cooperate = TRUE]
  let maxi-hc turtles-maxi with [ last best.history  = TRUE and cooperate = TRUE]
  let maxi-sd turtles-maxi with [ last best.history  = FALSE and cooperate = FALSE]
  let maxi-hd turtles-maxi with [ last best.history  = TRUE and cooperate = FALSE]
  
  
  
  let mini-t turtles-mini with [ cooperate = TRUE]
  let mini-f turtles-mini with [ cooperate = FALSE]
  let mini-h turtles-mini with [ last best.history  = TRUE]
  let mini-s turtles-mini with [ last best.history  = FALSE]
 
 
  let conf-t turtles-conf with [ cooperate = TRUE]
  let conf-f turtles-conf with [ cooperate = FALSE]
  let conf-h turtles-conf with [ last best.history  = TRUE]
  let conf-s turtles-conf with [ last best.history  = FALSE]
 
 
  let anti-t turtles-anti with [ cooperate = TRUE]
  let anti-f turtles-anti with [ cooperate = FALSE]
  let anti-h turtles-anti with [ last best.history  = TRUE]
  let anti-s turtles-anti with [ last best.history  = FALSE]
  
  let mini-sc turtles-mini with [ last best.history  = FALSE and cooperate = TRUE]
  let conf-sc turtles-conf with [ last best.history  = FALSE and cooperate = TRUE]
  let anti-sc turtles-anti with [ last best.history  = FALSE and cooperate = TRUE]
  
  let mini-hc turtles-mini with [ last best.history  = TRUE and cooperate = TRUE]
  let conf-hc turtles-conf with [ last best.history  = TRUE and cooperate = TRUE]
  let anti-hc turtles-anti with [ last best.history  = TRUE and cooperate = TRUE]
  
  
  let mini-sd turtles-mini with [ last best.history  = FALSE and cooperate = FALSE]
  let conf-sd turtles-conf with [ last best.history  = FALSE and cooperate = FALSE]
  let anti-sd turtles-anti with [ last best.history  = FALSE and cooperate = FALSE]

  
  let mini-hd turtles-mini with [ last best.history  = TRUE and cooperate = FALSE]
  let conf-hd turtles-conf with [ last best.history  = TRUE and cooperate = FALSE]
  let anti-hd turtles-anti with [ last best.history  = TRUE and cooperate = FALSE]
 

  set-current-plot "Scores Coop"
  set-current-plot-pen "mini"
  ifelse count mini-t > 0 [plot mean [score] of mini-t ][plot 0]

  set-current-plot "Scores Coop"
  set-current-plot-pen "conf"
  ifelse count conf-t > 0 [plot mean [score] of conf-t ][plot 0]  

  set-current-plot "Scores Coop"
  set-current-plot-pen "anti"
  ifelse count anti-t > 0 [plot mean [score] of anti-t ][plot 0]

  set-current-plot "Scores Defecting"
  set-current-plot-pen "maxi"
  ifelse count maxi-f > 0 [plot mean [score] of maxi-f ][plot 0]

  set-current-plot "Scores Defecting"
  set-current-plot-pen "mini"
  ifelse count mini-f > 0 [plot mean [score] of mini-f ][plot 0]

  set-current-plot "Scores Defecting"
  set-current-plot-pen "conf"
  ifelse count conf-f > 0 [plot mean [score] of conf-f ][plot 0]  

  set-current-plot "Scores Defecting"
  set-current-plot-pen "anti"
  ifelse count anti-f > 0 [plot mean [score] of anti-f ][plot 0]

  set-current-plot "Scores Happy"
  set-current-plot-pen "maxi"
  ifelse count maxi-h > 0 [plot mean [score] of maxi-h ][plot 0]
  set-current-plot "Scores Happy"
  set-current-plot-pen "mini"
  ifelse count mini-h > 0 [plot mean [score] of mini-h ][plot 0]
  set-current-plot "Scores Happy"
  set-current-plot-pen "conf"
  ifelse count conf-h > 0 [plot mean [score] of conf-h ][plot 0]  
  set-current-plot "Scores Happy"
  set-current-plot-pen "anti"
  ifelse count anti-h > 0 [plot mean [score] of anti-h ][plot 0]


  set-current-plot "Scores UnHappy"
  set-current-plot-pen "maxi"
  ifelse count maxi-s > 0 [plot mean [score] of maxi-s ][plot 0]
  set-current-plot "Scores UnHappy"
  set-current-plot-pen "mini"
  ifelse count mini-s > 0 [plot mean [score] of mini-s ][plot 0]
  set-current-plot "Scores UnHappy"
  set-current-plot-pen "conf"
  ifelse count conf-s > 0 [plot mean [score] of conf-s ][plot 0]  
  set-current-plot "Scores UnHappy"
  set-current-plot-pen "anti"
  ifelse count anti-s > 0 [plot mean [score] of anti-s ][plot 0]


  set-current-plot "S&C"
  set-current-plot-pen "maxi"
  ifelse count maxi-sc > 0[plot mean [score] of maxi-sc][plot 0]
  set-current-plot "S&C"
  set-current-plot-pen "mini"
  ifelse count mini-sc > 0[plot mean [score] of mini-sc][plot 0]
  set-current-plot "S&C"
  set-current-plot-pen "conf"
  ifelse count conf-sc > 0[plot mean [score] of conf-sc][plot 0]
  set-current-plot "S&C"
  set-current-plot-pen "anti"
  ifelse count anti-sc > 0[plot mean [score] of anti-sc][plot 0]


set-current-plot "H&C"
  set-current-plot-pen "maxi"
  ifelse count maxi-hc > 0[plot mean [score] of maxi-hc][plot 0]
set-current-plot "H&C"
  set-current-plot-pen "mini"
  ifelse count mini-hc > 0[plot mean [score] of mini-hc][plot 0]
set-current-plot "H&C"
  set-current-plot-pen "conf"
  ifelse count conf-hc > 0 [plot mean [score] of conf-hc][plot 0]
set-current-plot "H&C"
  set-current-plot-pen "anti"
  ifelse count anti-hc > 0 [plot mean [score] of anti-hc][plot 0]

set-current-plot "S&D"
  set-current-plot-pen "maxi"
  ifelse count maxi-sd > 0[plot mean [score] of maxi-sd][plot 0]
set-current-plot "S&D"
  set-current-plot-pen "mini"
  ifelse count mini-sd > 0[plot mean [score] of mini-sd][plot 0]
set-current-plot "S&D"
  set-current-plot-pen "conf"
  ifelse count conf-sd > 0[plot mean [score] of conf-sd][plot 0]
set-current-plot "S&D"
  set-current-plot-pen "anti"
  ifelse count anti-sd > 0[plot mean [score] of anti-sd][plot 0]

set-current-plot "H&D"
  set-current-plot-pen "maxi"
  ifelse count maxi-hd > 0[plot mean [score] of maxi-hd][plot 0]
set-current-plot "H&D"
  set-current-plot-pen "mini"
  ifelse count mini-hd > 0[plot mean [score] of mini-hd][plot 0]
set-current-plot "H&D"
  set-current-plot-pen "conf"
  ifelse count conf-hd > 0[plot mean [score] of conf-hd][plot 0]
set-current-plot "H&D"
  set-current-plot-pen "anti"
  ifelse count anti-hd > 0[plot mean [score] of anti-hd][plot 0]

set-current-plot "Sat S&C"
  set-current-plot-pen "maxi"
  ifelse count maxi-sc > 0[plot mean [satisfaction2] of maxi-sc][plot 0]
set-current-plot "Sat S&C"
  set-current-plot-pen "mini"
  ifelse count mini-sc > 0[plot mean [satisfaction2] of mini-sc][plot 0]
set-current-plot "Sat S&C"
  set-current-plot-pen "conf"
  ifelse count conf-sc > 0[plot mean [satisfaction2] of conf-sc][plot 0]
set-current-plot "Sat S&C"
  set-current-plot-pen "anti"
  ifelse count anti-sc > 0[plot mean [satisfaction2] of anti-sc][plot 0]


set-current-plot "Sat H&C"
  set-current-plot-pen "maxi"
  ifelse count maxi-hc > 0[plot mean [satisfaction2] of maxi-hc][plot 0]
set-current-plot "Sat H&C"
  set-current-plot-pen "mini"
  ifelse count mini-hc > 0[plot mean [satisfaction2] of mini-hc][plot 0]
set-current-plot "Sat H&C"
  set-current-plot-pen "conf"
  ifelse count conf-hc > 0 [plot mean [satisfaction2] of conf-hc][plot 0]
set-current-plot "Sat H&C"
  set-current-plot-pen "anti"
  ifelse count anti-hc > 0 [plot mean [satisfaction2] of anti-hc][plot 0]

set-current-plot "Sat S&D"
  set-current-plot-pen "maxi"
  ifelse count maxi-sd > 0[plot mean [satisfaction2] of maxi-sd][plot 0]
set-current-plot "Sat S&D"
  set-current-plot-pen "mini"
  ifelse count mini-sd > 0[plot mean [satisfaction2] of mini-sd][plot 0]
set-current-plot "Sat S&D"
  set-current-plot-pen "conf"
  ifelse count conf-sd > 0[plot mean [satisfaction2] of conf-sd][plot 0]
set-current-plot "Sat S&D"
  set-current-plot-pen "anti"
  ifelse count anti-sd > 0[plot mean [satisfaction2] of anti-sd][plot 0]

set-current-plot "Sat H&D"
  set-current-plot-pen "maxi"
  ifelse count maxi-hd > 0[plot mean [satisfaction2] of maxi-hd][plot 0]
set-current-plot "Sat H&D"
  set-current-plot-pen "mini"
  ifelse count mini-hd > 0[plot mean [satisfaction2] of mini-hd][plot 0]
set-current-plot "Sat H&D"
  set-current-plot-pen "conf"
  ifelse count conf-hd > 0[plot mean [satisfaction2] of conf-hd][plot 0]
set-current-plot "Sat H&D"
  set-current-plot-pen "anti"
  ifelse count anti-hd > 0[plot mean [satisfaction2] of anti-hd][plot 0]

set-current-plot "Sat Coop"
  set-current-plot-pen "maxi"
  ifelse count maxi-t > 0 [plot mean [satisfaction2] of maxi-t ][plot 0]
set-current-plot "Sat Coop"
  set-current-plot-pen "mini"
  ifelse count mini-t > 0 [plot mean [satisfaction2] of mini-t ][plot 0]
set-current-plot "Sat Coop"
  set-current-plot-pen "conf"
  ifelse count conf-t > 0 [plot mean [satisfaction2] of conf-t ][plot 0]  
set-current-plot "Sat Coop"
  set-current-plot-pen "anti"
  ifelse count anti-t > 0 [plot mean [satisfaction2] of anti-t ][plot 0]

  set-current-plot "Sat Defecting"
  set-current-plot-pen "maxi"
  ifelse count maxi-f > 0 [plot mean [satisfaction2] of maxi-f ][plot 0]
  set-current-plot "Sat Defecting"
  set-current-plot-pen "mini"
  ifelse count mini-f > 0 [plot mean [satisfaction2] of mini-f ][plot 0]
  set-current-plot "Sat Defecting"
  set-current-plot-pen "conf"
  ifelse count conf-f > 0 [plot mean [satisfaction2] of conf-f ][plot 0]  
  set-current-plot "Sat Defecting"
  set-current-plot-pen "anti"
  ifelse count anti-f > 0 [plot mean [satisfaction2] of anti-f ][plot 0]

  set-current-plot "Sat Happy"
  set-current-plot-pen "maxi"
  ifelse count maxi-h > 0 [plot mean [satisfaction2] of maxi-h ][plot 0]
  set-current-plot "Sat Happy"
  set-current-plot-pen "mini"
  ifelse count mini-h > 0 [plot mean [satisfaction2] of mini-h ][plot 0]
  set-current-plot "Sat Happy"
  set-current-plot-pen "conf"
  ifelse count conf-h > 0 [plot mean [satisfaction2] of conf-h ][plot 0]  
  set-current-plot "Sat Happy"
  set-current-plot-pen "anti"
  ifelse count anti-h > 0 [plot mean [satisfaction2] of anti-h ][plot 0]


  set-current-plot "Sat UnHappy"
  set-current-plot-pen "maxi"
  ifelse count maxi-s > 0 [plot mean [satisfaction2] of maxi-s ][plot 0]
  set-current-plot "Sat UnHappy"
  set-current-plot-pen "mini"
  ifelse count mini-s > 0 [plot mean [satisfaction2] of mini-s ][plot 0]
  set-current-plot "Sat UnHappy"
  set-current-plot-pen "conf"
  ifelse count conf-s > 0 [plot mean [satisfaction2] of conf-s ][plot 0]  
  set-current-plot "Sat UnHappy"
  set-current-plot-pen "anti"
  ifelse count anti-s > 0 [plot mean [satisfaction2] of anti-s ][plot 0]


  set-current-plot "Maxi Neighbors"
  set-current-plot-pen "maxi"
  ifelse  maxi > 0 [plot   mean [last n.maxi.list]  of turtles-maxi][plot 0]
  set-current-plot "Maxi Neighbors"
  set-current-plot-pen "mini"
  ifelse  mini > 0 [plot mean [last n.mini.list]  of turtles-maxi][plot 0]
  set-current-plot "Maxi Neighbors"
  set-current-plot-pen "conf"
  ifelse  conf > 0 [plot mean [last n.conf.list]  of turtles-maxi][plot 0]  
  set-current-plot "Maxi Neighbors"
  set-current-plot-pen "anti"
  ifelse  anti > 0 [plot mean [last n.anti.list]  of turtles-maxi ][plot 0]

  set-current-plot "Mini Neighbors"
  set-current-plot-pen "maxi"
  ifelse  maxi > 0 [plot   mean [last n.maxi.list]  of turtles-mini][plot 0]
  set-current-plot "Mini Neighbors"
  set-current-plot-pen "mini"
  ifelse  mini > 0 [plot mean [last n.mini.list]  of turtles-mini][plot 0]
  set-current-plot "Mini Neighbors"
  set-current-plot-pen "conf"
  ifelse  conf > 0 [plot mean [last n.conf.list]  of turtles-mini][plot 0]  
  set-current-plot "Mini Neighbors"
  set-current-plot-pen "anti"
  ifelse  anti > 0 [plot mean [last n.anti.list]  of turtles-mini ][plot 0]

  set-current-plot "Conf Neighbors"
  set-current-plot-pen "maxi"
  ifelse  maxi > 0 [plot   mean [last n.maxi.list]  of turtles-conf][plot 0]
  set-current-plot "Conf Neighbors"
  set-current-plot-pen "mini"
  ifelse  mini > 0 [plot mean [last n.mini.list]  of turtles-conf][plot 0]
  set-current-plot "Conf Neighbors"
  set-current-plot-pen "conf"
  ifelse  conf > 0 [plot mean [last n.conf.list]  of turtles-conf][plot 0]  
  set-current-plot "Conf Neighbors"
  set-current-plot-pen "anti"
  ifelse  anti > 0 [plot mean [last n.anti.list]  of turtles-conf ][plot 0]

  set-current-plot "Anti Neighbors"
  set-current-plot-pen "maxi"
  ifelse  maxi > 0 [plot   mean [last n.maxi.list]  of turtles-anti][plot 0]
  set-current-plot "Anti Neighbors"
  set-current-plot-pen "mini"
  ifelse  mini > 0 [plot mean [last n.mini.list]  of turtles-anti][plot 0]
  set-current-plot "Anti Neighbors"
  set-current-plot-pen "conf"
  ifelse  conf > 0 [plot mean [last n.conf.list]  of turtles-anti][plot 0]  
  set-current-plot "Anti Neighbors"
  set-current-plot-pen "anti"
  ifelse  anti > 0 [plot mean [last n.anti.list]  of turtles-anti ][plot 0]
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




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; EXPORT LOGO;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to export-age-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Ages.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist age.history (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-rules-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Rules.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist rule.history (p - Binterval) (p - 1 ) ) )
      file-close
      ]
]
end


to export-behavior-L
let spacer ","
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Behavior.csv")
foreach sort-on [NODEID] turtles
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist behavior.history (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-satisfaction-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Satisfaction.csv")

let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist satisfaction.history (p - Binterval) (p - 1) ) )
     file-close
      ]
]
end

to export-scores-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Scores.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist scores.history (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-best-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Best.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist best.history (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end


to export-prop1-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Maxi.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.maxi.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end

to export-prop2-L 
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Mini.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.mini.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end


to export-prop3-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str  "Conf.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.conf.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end


to export-prop4-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Anti.csv")
let spacer ","
let l sort-on [NODEID] turtles
foreach l
[
ask ? [
      file-open file.name
      file-print (list run.info spacer NODEID spacer who spacer (sublist n.anti.list (p - Binterval) (p - 1) ) )
      file-close
      ]
]
end


to export-global-L
let p length [rule.history] of turtle 1 
let str [run.info] of turtle 1
let file.name (word str "Global.csv")
let spacer ","
let info [run.info] of turtle 1
let lista1    []
let lista2    []
let lista3    []
let lista4    []
let lista5    []
let lista6    []
let lista7    []
let lista8    []
let lista9    []
let lista10   []
let lista11   []
let lista12   []
let lista13  []
let lista14  []
let lista15  []
let lista16  []
let lista17  []
let lista18  []
let lista19  []
let lista20  []
let lista21  []
let lista22  []
let lista23  []
let lista24  []
let lista25  []
let lista26  []
let lista27  []
let lista28  []
let lista29  []
let lista30  []
let lista31  []
let lista32  []
let lista33  []
let lista34  []
let lista35  []
let lista36  []
let lista37  []
let lista38  []
let lista39  []
let lista40  []
let lista41  []
let lista42  []
let lista43  []
let lista44  []
let lista45  []
let lista46  []
let lista47  []
let lista48  []
let lista49  []
let lista50  []
let lista51  []
let lista52  []
let lista53  []
let lista54  []
let lista55  []
let lista56  []
let lista57  []
let lista58  []
let lista59  []
let lista60  []
let lista61  []
let lista62  []
let lista63  []
let lista64  []
let lista65  []
let lista66  []
let lista67  []
let lista68  []
let lista69  []
let  lista1b  []       
let  lista2b  []       
let  lista3b  []       
let  lista4b  []       
let  lista5b  []       
let  lista6b  []       
let  lista7b  []       
let  lista8b  []       
let  lista9b  []       
let  lista10b  []      
let  lista11b  []      
let  lista12b  []      
 let lista13b  []      
 let lista14b  []      
 let lista15b  []      
 let lista16b  []      
 let lista17b  []      
 let lista18b  []      
 let lista19b  []      
 let lista20b  []      
 let lista21b  []      
 let lista22b  []      
 let lista23b  []      
 let lista24b  []      
 let lista25b  []      
 let lista26b  []      
 let lista27b  []      
 let lista28b  []      
 let lista29b  []      
 let lista30b  []      
 let lista31b  []      
 let lista32b  []      
 let lista33b  []      
 let lista34b  []      
 let lista35b  []      
 let lista36b  []      
 let lista37b  []      
 let lista38b  []      
 let lista39b  []      
 let lista40b  []      
 let lista41b  []      
 let lista42b  []      
 let lista43b  []      
 let lista44b  []      
 let lista45b  []      
 let lista46b  []      
 let lista47b  []      
 let lista48b  []      
 let lista49b  []      
 let lista50b  []      
 let lista51b  []      
 let lista52b  []      
 let lista53b  []      
 let lista54b  []      
 let lista55b  []      
 let lista56b  []      
 let lista57b  []      
 let lista58b  []      
 let lista59b  []      
 let lista60b  []      
 let lista61b  []      
 let lista62b  []      
 let lista63b  []      
 let lista64b  []      
 let lista65b  []      
 let lista66b  []      
 let lista67b  []      
 let lista68b  []      
 let lista69b  []      


let lista filter [? > -1] (sublist mean.max       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista1 "NA"] [set lista1 mean lista]
ifelse length lista < 2 [set lista1b "NA"] [set lista1b sqrt variance lista]

set lista filter [? > -1] (sublist mean.min       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista2 "NA" ][set lista2 mean lista]
ifelse length lista < 2 [set lista2b "NA" ][set lista2b sqrt variance lista]

set lista filter [? > -1] (sublist mean.conf      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista3 "NA" ][set lista3 mean lista]
ifelse length lista < 2 [set lista3b "NA" ][set lista3b sqrt variance lista]

set lista filter [? > -1] (sublist mean.anti      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista4 "NA" ][set lista4 mean lista]
ifelse length lista < 2 [set lista4b "NA" ][set lista4b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.max   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista5 "NA" ][set lista5 mean lista]
ifelse length lista < 2 [set lista5b "NA" ][set lista5b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.min   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista6 "NA" ][set lista6 mean lista]
ifelse length lista < 2 [set lista6b "NA" ][set lista6b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.conf  (p - averages-length) (p - 1) )
ifelse empty? lista [set lista7 "NA" ][set lista7 mean lista]
ifelse length lista < 2 [set lista7b "NA" ][set lista7b sqrt variance lista]

set lista filter [? > -1] (sublist mean.age.anti  (p - averages-length) (p - 1) )
ifelse empty? lista [set lista8 "NA" ][set lista8 mean lista]
ifelse length lista < 2 [set lista8b "NA" ][set lista8b sqrt variance lista]

set lista filter [? > -1] (sublist coop.maxi      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista9 "NA" ][set lista9 mean lista]
ifelse length lista < 2 [set lista9b "NA" ][set lista9b sqrt variance lista]

set lista filter [? > -1] (sublist coop.mini      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista10 "NA" ][set lista10 mean lista]
ifelse length lista < 2 [set lista10b "NA" ][set lista10b sqrt variance lista]

set lista filter [? > -1] (sublist coop.conf      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista11 "NA" ][set lista11 mean lista]
ifelse length lista < 2 [set lista11b "NA" ][set lista11b sqrt variance lista]

set lista filter [? > -1] (sublist coop.anti      (p - averages-length) (p - 1) )
ifelse empty? lista [set lista12 "NA" ][set lista12 mean lista]
ifelse length lista < 2 [set lista12b "NA" ][set lista12b sqrt variance lista]

set lista filter [? > -1] (sublist sat.maxi       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista13 "NA" ][set lista13 mean lista]
ifelse length lista < 2 [set lista13b "NA" ][set lista13b sqrt variance lista]

set lista filter [? > -1] (sublist mean.sat       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista14 "NA" ][set lista14 mean lista]
ifelse length lista < 2 [set lista14b "NA" ][set lista14b sqrt variance lista]

set lista filter [? > -1] (sublist sat.mini       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista15 "NA" ][set lista15 mean lista]
ifelse length lista < 2 [set lista15b "NA" ][set lista15b sqrt variance lista]

set lista filter [? > -1] (sublist sat.conf       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista16 "NA" ][set lista16 mean lista]
ifelse length lista < 2 [set lista16b "NA" ][set lista16b sqrt variance lista]

set lista filter [? > -1] (sublist sat.anti       (p - averages-length) (p - 1) )
ifelse empty? lista [set lista17 "NA" ][set lista17 mean lista]
ifelse length lista < 2 [set lista17b "NA" ][set lista17b sqrt variance lista]

set lista filter [? > -1] (sublist scores.maxi    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista18 "NA" ][set lista18 mean lista]
ifelse length lista < 2 [set lista18b "NA" ][set lista18b sqrt variance lista]

set lista filter [? > -1] (sublist scores.mini    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista19 "NA" ][set lista19 mean lista]
ifelse length lista < 2 [set lista19b "NA" ][set lista19b sqrt variance lista]

set lista filter [? > -1] (sublist scores.conf    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista20 "NA" ][set lista20 mean lista]
ifelse length lista < 2[set lista20b "NA" ][set lista20b sqrt variance lista]

set lista filter [? > -1] (sublist scores.anti    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista21 "NA" ][set lista21 mean lista]
ifelse length lista < 2[set lista21b "NA" ][set lista21b sqrt variance lista]

set lista filter [? > -1] (sublist CH.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista22 "NA" ][set lista22 mean lista]
ifelse length lista < 2[set lista22b "NA" ][set lista22b sqrt variance lista]

set lista filter [? > -1] (sublist CH.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista23 "NA" ][set lista23 mean lista]
ifelse length lista < 2[set lista23b "NA" ][set lista23b sqrt variance lista]

set lista filter [? > -1] (sublist CH.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista24 "NA" ][set lista24 mean lista]
ifelse length lista < 2[set lista24b "NA" ][set lista24b sqrt variance lista]

set lista filter [? > -1] (sublist CH.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista25 "NA" ][set lista25 mean lista]
ifelse length lista < 2[set lista25b "NA" ][set lista25b sqrt variance lista]

set lista filter [? > -1] (sublist CU.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista26 "NA" ][set lista26 mean lista]
ifelse length lista < 2[set lista26b "NA" ][set lista26b sqrt variance lista]

set lista filter [? > -1] (sublist CU.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista27 "NA" ][set lista27 mean lista]
ifelse length lista < 2[set lista27b "NA" ][set lista27b sqrt variance lista]

set lista filter [? > -1] (sublist CU.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista28 "NA" ][set lista28 mean lista]
ifelse length lista < 2[set lista28b "NA" ][set lista28b sqrt variance lista]

set lista filter [? > -1] (sublist CU.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista29 "NA" ][set lista29 mean lista]
ifelse length lista < 2[set lista29b "NA" ][set lista29b sqrt variance lista]

set lista filter [? > -1] (sublist DH.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista30 "NA" ][set lista30 mean lista]
ifelse length lista < 2[set lista30b "NA" ][set lista30b sqrt variance lista]

set lista filter [? > -1] (sublist DH.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista31 "NA" ][set lista31 mean lista]
ifelse length lista < 2[set lista31b "NA" ][set lista31b sqrt variance lista]

set lista filter [? > -1] (sublist DH.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista32 "NA" ][set lista32 mean lista]
ifelse length lista < 2[set lista32b "NA" ][set lista32b sqrt variance lista]

set lista filter [? > -1] (sublist DH.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista33 "NA" ][set lista33 mean lista]
ifelse length lista < 2[set lista33b "NA" ][set lista33b sqrt variance lista]

set lista filter [? > -1] (sublist DU.maxi.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista34 "NA" ][set lista34 mean lista]
ifelse length lista < 2[set lista34b "NA" ][set lista34b sqrt variance lista]

set lista filter [? > -1] (sublist DU.mini.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista35 "NA" ][set lista35 mean lista]
ifelse length lista < 2[set lista35b "NA" ][set lista35b sqrt variance lista]

set lista filter [? > -1] (sublist DU.conf.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista36 "NA" ][set lista36 mean lista]
ifelse length lista < 2[set lista36b "NA" ][set lista36b sqrt variance lista]

set lista filter [? > -1] (sublist DU.anti.prop   (p - averages-length) (p - 1) )
ifelse empty? lista [set lista37 "NA" ][set lista37 mean lista]
ifelse length lista < 2[set lista37b "NA" ][set lista37b sqrt variance lista]

set lista filter [? > -1] (sublist CH.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista38 "NA" ][set lista38 mean lista]
ifelse length lista < 2[set lista38b "NA" ][set lista38b sqrt variance lista]

set lista filter [? > -1] (sublist CH.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista39 "NA" ][set lista39 mean lista]
ifelse length lista < 2[set lista39b "NA" ][set lista39b sqrt variance lista]

set lista filter [? > -1] (sublist CH.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista40 "NA" ][set lista40 mean lista]
ifelse length lista < 2[set lista40b "NA" ][set lista40b sqrt variance lista]

set lista filter [? > -1] (sublist CH.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista41 "NA" ][set lista41 mean lista]
ifelse length lista < 2[set lista41b "NA" ][set lista41b sqrt variance lista]

set lista filter [? > -1] (sublist CU.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista42 "NA" ][set lista42 mean lista]
ifelse length lista < 2[set lista42b "NA" ][set lista42b sqrt variance lista]

set lista filter [? > -1] (sublist CU.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista43 "NA" ][set lista43 mean lista]
ifelse length lista < 2[set lista43b "NA" ][set lista43b sqrt variance lista]

set lista filter [? > -1] (sublist CU.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista44 "NA" ][set lista44 mean lista]
ifelse length lista < 2[set lista44b "NA" ][set lista44b sqrt variance lista]

set lista filter [? > -1] (sublist CU.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista45 "NA" ][set lista45 mean lista]
ifelse length lista < 2[set lista45b "NA" ][set lista45b sqrt variance lista]

set lista filter [? > -1] (sublist DH.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista46 "NA" ][set lista46 mean lista]
ifelse length lista < 2[set lista46b "NA" ][set lista46b sqrt variance lista]

set lista filter [? > -1] (sublist DH.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista47 "NA" ][set lista47 mean lista]
ifelse length lista < 2[set lista47b "NA" ][set lista47b sqrt variance lista]

set lista filter [? > -1] (sublist DH.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista48 "NA" ][set lista48 mean lista]
ifelse length lista < 2[set lista48b "NA" ][set lista48b sqrt variance lista]

set lista filter [? > -1] (sublist DH.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista49 "NA" ][set lista49 mean lista]
ifelse length lista < 2[set lista49b "NA" ][set lista49b sqrt variance lista]

set lista filter [? > -1] (sublist DU.maxi.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista50 "NA" ][set lista50 mean lista]
ifelse length lista < 2[set lista50b "NA" ][set lista50b sqrt variance lista]

set lista filter [? > -1] (sublist DU.mini.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista51 "NA" ][set lista51 mean lista]
ifelse length lista < 2[set lista51b "NA" ][set lista51b sqrt variance lista]

set lista filter [? > -1] (sublist DU.conf.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista52 "NA" ][set lista52 mean lista]
ifelse length lista < 2[set lista52b "NA" ][set lista52b sqrt variance lista]

set lista filter [? > -1] (sublist DU.anti.sat    (p - averages-length) (p - 1) )
ifelse empty? lista [set lista53 "NA" ][set lista53 mean lista]
ifelse length lista < 2[set lista53b "NA" ][set lista53b sqrt variance lista]

set lista filter [? > -1] (sublist CH.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista54 "NA" ][set lista54 mean lista]
ifelse length lista < 2[set lista54b "NA" ][set lista54b sqrt variance lista]

set lista filter [? > -1] (sublist CH.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista55 "NA" ][set lista55 mean lista]
ifelse length lista < 2[set lista55b "NA" ][set lista55b sqrt variance lista]

set lista filter [? > -1] (sublist CH.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista56 "NA" ][set lista56 mean lista]
ifelse length lista < 2[set lista56b "NA" ][set lista56b sqrt variance lista]

set lista filter [? > -1] (sublist CH.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista57 "NA" ][set lista57 mean lista]
ifelse length lista < 2[set lista57b "NA" ][set lista57b sqrt variance lista]

set lista filter [? > -1] (sublist CU.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista58 "NA" ][set lista58 mean lista]
ifelse length lista < 2[set lista58b "NA" ][set lista58b sqrt variance lista]

set lista filter [? > -1] (sublist CU.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista59 "NA" ][set lista59 mean lista]
ifelse length lista < 2[set lista59b "NA" ][set lista59b sqrt variance lista]

set lista filter [? > -1] (sublist CU.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista60 "NA" ][set lista60 mean lista]
ifelse length lista < 2[set lista60b "NA" ][set lista60b sqrt variance lista]

set lista filter [? > -1] (sublist CU.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista61 "NA" ][set lista61 mean lista]
ifelse length lista < 2[set lista61b "NA" ][set lista61b sqrt variance lista]

set lista filter [? > -1] (sublist DH.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista62 "NA" ][set lista62 mean lista]
ifelse length lista < 2[set lista62b "NA" ][set lista62b sqrt variance lista]

set lista filter [? > -1] (sublist DH.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista63 "NA" ][set lista63 mean lista]
ifelse length lista < 2[set lista63b "NA" ][set lista63b sqrt variance lista]

set lista filter [? > -1] (sublist DH.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista64 "NA" ][set lista64 mean lista]
ifelse length lista < 2[set lista64b "NA" ][set lista64b sqrt variance lista]

set lista filter [? > -1] (sublist DH.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista65 "NA" ][set lista65 mean lista]
ifelse length lista < 2[set lista65b "NA" ][set lista65b sqrt variance lista]

set lista filter [? > -1] (sublist DU.maxi.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista66 "NA" ][set lista66 mean lista]
ifelse length lista < 2[set lista66b "NA" ][set lista66b sqrt variance lista]

set lista filter [? > -1] (sublist DU.mini.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista67 "NA" ][set lista67 mean lista]
ifelse length lista < 2[set lista67b "NA" ][set lista67b sqrt variance lista]

set lista filter [? > -1] (sublist DU.conf.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista68 "NA" ][set lista68 mean lista]
ifelse length lista < 2[set lista68b "NA" ][set lista68b sqrt variance lista]

set lista filter [? > -1] (sublist DU.anti.scores (p - averages-length) (p - 1) )
ifelse empty? lista [set lista69 "NA" ][set lista69 mean lista]
ifelse length lista < 2[set lista69b "NA" ][set lista69b sqrt variance lista]

file-open file.name
file-print (list  info spacer 
mean (sublist mean.scores    (p - averages-length) (p - 1) ) spacer 
mean (sublist mean.coop      (p - averages-length) (p - 1) ) spacer  
lista1    spacer  lista2    spacer  lista3    spacer lista4    spacer 
lista5    spacer  lista6    spacer  lista7    spacer lista8    spacer 
lista9    spacer  lista10   spacer  lista11   spacer lista12   spacer 
lista13  spacer   lista14  spacer  lista15  spacer  lista16  spacer 
lista17  spacer   lista18  spacer  lista19  spacer  lista20  spacer 
lista21  spacer   lista22  spacer  lista23  spacer  lista24  spacer 
lista25  spacer   lista26  spacer  lista27  spacer  lista28  spacer 
lista29  spacer   lista30  spacer  lista31  spacer  lista32  spacer 
lista33  spacer   lista34  spacer  lista35  spacer  lista36  spacer 
lista37  spacer   lista38  spacer  lista39  spacer  lista40  spacer 
lista41  spacer  lista42  spacer  lista43  spacer  lista44  spacer 
lista45  spacer  lista46  spacer  lista47  spacer  lista48  spacer 
lista49  spacer  lista50  spacer  lista51  spacer  lista52  spacer 
lista53  spacer  lista54  spacer  lista55  spacer  lista56  spacer 
lista57  spacer  lista58  spacer  lista59  spacer  lista60  spacer 
lista61  spacer  lista62  spacer  lista63  spacer  lista64  spacer 
lista65  spacer  lista66  spacer  lista67  spacer  lista68  spacer 
lista69  spacer  sqrt variance (sublist mean.scores    (p - averages-length) (p - 1) ) spacer 
sqrt variance (sublist mean.coop      (p - averages-length) (p - 1) ) spacer  
lista1b    spacer  lista2b    spacer  lista3b    spacer lista4b    spacer 
lista5b    spacer  lista6b    spacer  lista7b    spacer lista8b    spacer 
lista9b    spacer  lista10b   spacer  lista11b   spacer lista12b   spacer 
lista13b  spacer   lista14b  spacer  lista15b spacer  lista16b  spacer 
lista17b  spacer   lista18b  spacer  lista19b  spacer  lista20b  spacer 
lista21b  spacer   lista22b  spacer  lista23b  spacer  lista24b  spacer 
lista25b  spacer   lista26b  spacer  lista27b  spacer  lista28b  spacer 
lista29b  spacer   lista30b  spacer  lista31b  spacer  lista32b  spacer 
lista33b  spacer   lista34b  spacer  lista35b  spacer  lista36b  spacer 
lista37b  spacer   lista38b  spacer  lista39b  spacer  lista40b  spacer 
lista41b  spacer  lista42b  spacer  lista43b  spacer  lista44b  spacer 
lista45b  spacer  lista46b  spacer  lista47b  spacer  lista48b  spacer 
lista49b  spacer  lista50b  spacer  lista51b  spacer  lista52b  spacer 
lista53b  spacer  lista54b  spacer  lista55b  spacer  lista56b  spacer 
lista57b  spacer  lista58b  spacer  lista59b  spacer  lista60b  spacer 
lista61b  spacer  lista62b  spacer  lista63b  spacer  lista64b  spacer 
lista65b  spacer  lista66b  spacer  lista67b  spacer  lista68b  spacer 
lista69b ) 

file-close

end







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Layout  ;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Layout code citation
;Wilensky, U. (2005). NetLogo Preferential Attachment model. http://ccl.northwestern.edu/netlogo/models/PreferentialAttachment. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
;Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

;; resize-nodes, change back and forth from size based on degree to a size of 1
to resize-nodes
  ifelse all? turtles [size = 3]
  [
   ask turtles [ set size sqrt degree ]
  ]
  [
    ask turtles [ set size 3 ]
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

ask links [set color black]

set success? true
;set average-path-length nw:mean-path-length 
spread-turtles
;set sizeT [size] of one-of turtles 

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

ask turtles [set size ceiling sqrt distance  (  one-of link-neighbors ) * 1.5]
ask turtles [set size min (list horizontal-spacing vertical-spacing)]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Random Network ;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to Create-Random-Network 
  ;; Make a circle of turtles
  create-turtles Num-Agents
  layout-circle sort turtles  (plot.radius )

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
layout-circle sort turtles  (plot.radius )

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
layout-circle sort turtles (plot.radius )
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
;ask turtles [set size 10]
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
ask links [set color gray]
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
layout-circle turtles plot.radius
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

to-report do-calculations
  
  let connected? true  
  let mean-path-length nw:mean-path-length
  if not is-number? mean-path-length [set connected? false]
  report connected?
end
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
461
163
547
*Strategies colormap\n\nRed        Maxi\nGreen     Mini\nBlue     Conformist\nWhite      Anti-conf\n                      \n                       
9
0.0
0

SLIDER
402
32
583
65
*-strength-of-dilemma
*-strength-of-dilemma
0
0.5
0.5
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
"Scores" 1.0 0 -10899396 true "" ""

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
70
579
103
*-inicoop
*-inicoop
0
100
25
1
1
NIL
HORIZONTAL

SLIDER
392
468
593
501
*-Connection-Probability
*-Connection-Probability
0.01
1
1
.001
1
NIL
HORIZONTAL

INPUTBOX
493
394
569
454
*-Num-Agents
1000
1
0
Number

TEXTBOX
393
378
567
396
*Choose Topology\n
10
15.0
1

CHOOSER
398
406
490
451
*-Topology
*-Topology
"Random" "Small-World" "Scale-Free" "Lattice"
1

TEXTBOX
395
456
605
474
Random Network Connection Probability
9
0.0
1

TEXTBOX
396
506
546
524
Small World Parameters
9
0.0
1

SLIDER
393
553
591
586
*-Rewiring-Probability
*-Rewiring-Probability
0
1
0.087
.001
1
NIL
HORIZONTAL

SLIDER
393
601
590
634
*-Scale-Free-Exponent
*-Scale-Free-Exponent
1.5
3.1
0
.01
1
NIL
HORIZONTAL

TEXTBOX
398
589
548
607
Scale-Free Exponent
9
0.0
1

TEXTBOX
147
464
255
540
*Behaviour Colormap\n\nBlue   Cooperate\nOrange Defect
9
0.0
1

TEXTBOX
380
16
555
34
*Prisoner's Dilemma Parameters
9
15.0
1

SLIDER
394
517
591
550
*-Initial-Neighbours
*-Initial-Neighbours
1
*-Num-Agents - 1
10
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
maxi * 100 / Num-Agents
2
1
11

MONITOR
744
154
802
199
Mini %
mini * 100 / Num-Agents
2
1
11

MONITOR
683
202
743
247
Conf %
conf * 100 / Num-Agents
2
1
11

MONITOR
744
202
803
247
Anti %
anti * 100 / Num-Agents
2
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
382
127
591
151
*Add noise by replacing the population?
9
15.0
1

SWITCH
634
442
809
475
*-Initial-Random-Types?
*-Initial-Random-Types?
0
1
-1000

TEXTBOX
636
427
806
446
*Random Assignation of Types?
9
0.0
1

INPUTBOX
633
491
718
551
*-Initial-Maxi-%
100
1
0
Number

INPUTBOX
720
491
803
551
*-Initial-Mini-%
0
1
0
Number

INPUTBOX
634
551
717
611
*-Initial-Conf-%
0
1
0
Number

MONITOR
723
553
807
598
Initial-Anti-%
100 - *-Initial-Maxi-% - *-Initial-Mini-% - *-Initial-Conf-%
0
1
11

TEXTBOX
634
477
821
497
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
395
366
562
386
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
cooperation-rate * 100
2
1
11

MONITOR
708
73
804
118
Satisfaction %
satisfaction-rate2 * 100
2
1
11

SWITCH
396
250
563
283
Load-Topology
Load-Topology
0
1
-1000

INPUTBOX
395
288
568
348
*-fileIn
PGPFinal.graphml
1
0
String

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
1136
15
1303
135
Scores Coop
NIL
Score
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"maxi" 1.0 2 -2674135 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"conf" 1.0 2 -13345367 true "" ""
"anti" 1.0 2 -16777216 true "" ""

BUTTON
262
463
335
496
Layout
repeat 20 [layout]
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
254
497
333
530
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
396
143
547
176
*-replacement?
*-replacement?
0
1
-1000

MONITOR
630
153
680
198
% New Turtles
;count turtles with [shape = \"target\"] * 100 / count turtles
2
1
11

TEXTBOX
653
410
803
428
*Choose types distribution
9
15.0
1

SLIDER
396
177
568
210
*-cultural-constant
*-cultural-constant
-1
20
2
1
1
NIL
HORIZONTAL

MONITOR
629
202
679
247
Mean Age 
;mean [age] of turtles
2
1
11

BUTTON
176
406
316
439
reset-turtles
setup-init-turtles
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
1138
139
1298
260
Scores Happy
NIL
score
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"maxi" 1.0 2 -2674135 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"conf" 1.0 2 -13345367 true "" ""
"anti" 1.0 2 -16777216 true "" ""

PLOT
1142
266
1302
386
H&C
NIL
score
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1303
265
1463
385
H&D
NIL
score
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"maxi" 1.0 2 -2674135 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"conf" 1.0 2 -13345367 true "" ""
"anti" 1.0 2 -16777216 true "" ""

PLOT
1142
386
1302
506
S&C
NIL
score
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1303
386
1463
507
S&D
NIL
score
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"conf" 1.0 2 -13345367 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"mini" 1.0 2 -10899396 true "" ""

PLOT
1632
15
1792
135
Sat Defecting
NIL
satisfaction 
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1300
139
1460
260
scores UnHappy
NIL
score
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1303
16
1463
137
Scores Defecting
NIL
NIL
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1469
15
1629
136
Sat Coop
NIL
satisfaction
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1470
139
1630
260
Sat Happy
NIL
satisfaction
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1635
139
1795
260
Sat UnHappy
NIL
satisfaction
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -7500403 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1470
260
1630
381
Sat H&C
NIL
satisfaction
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1638
263
1798
384
Sat H&D
NIL
satisfaction
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1472
386
1632
507
Sat S&C
NIL
satisfaction
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1639
385
1799
506
Sat S&D
NIL
satisfaction
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

BUTTON
225
533
333
568
layout circle
layout-circle turtles plot.radius
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
1143
511
1303
632
Maxi Neighbors
NIL
NIL
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1305
509
1465
630
Mini Neighbors
NIL
NIL
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1640
508
1800
629
Anti Neighbors
NIL
NIL
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

PLOT
1472
509
1632
630
Conf Neighbors
NIL
NIL
0.0
500.0
0.0
1.0
true
false
"" ""
PENS
"anti" 1.0 2 -16777216 true "" ""
"mini" 1.0 2 -10899396 true "" ""
"maxi" 1.0 2 -2674135 true "" ""
"conf" 1.0 2 -13345367 true "" ""

TEXTBOX
388
229
538
247
*Load Graph
10
15.0
1

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
Conformist: The agent tries to behave as the majority   
Anti-conformist: The agent tries to behave as the minority
   
## HOW TO USE IT

Decide what percentage of agents should cooperate at the initial stage.

Decide the topology structure or load one.

If you are not loading a topology; choose the parameters for the desired topology. Notice the size of the lattice is fixed and you can't change the number of agents.

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
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
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
  <experiment name="ASW2" repetitions="10" runMetricsEveryStep="true">
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
    <steppedValueSet variable="*-Rewiring-Probability" first="0" step="0.1" last="1"/>
    <enumeratedValueSet variable="*-Initial-Neighbours">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-inicoop">
      <value value="0"/>
      <value value="5"/>
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="*-strength-of-dilemma" first="0" step="0.1" last="0.5"/>
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
  <experiment name="ASW3" repetitions="10" runMetricsEveryStep="false">
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
    <steppedValueSet variable="*-Rewiring-Probability" first="0" step="0.1" last="1"/>
    <enumeratedValueSet variable="*-Initial-Neighbours">
      <value value="12"/>
      <value value="50"/>
      <value value="75"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-inicoop">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="*-strength-of-dilemma" first="0" step="0.1" last="0.5"/>
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
  <experiment name="REALGRAPHS" repetitions="1" runMetricsEveryStep="true">
    <go>run-logo 200 190 9 9</go>
    <final>export-behavior-L
export-satisfaction-L
export-scores-L
export-best-L
export-age-L
export-prop1-L
export-prop2-L
export-prop3-L
export-prop4-L
export-global-L</final>
    <enumeratedValueSet variable="*-Initial-Mini-%">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-replacement?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Maxi-%">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Topology">
      <value value="&quot;Small-World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Random-Types?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-strength-of-dilemma">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Neighbours">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Rewiring-Probability">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Scale-Free-Exponent">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Load-Topology">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Initial-Conf-%">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Connection-Probability">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-inicoop">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-cultural-constant">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Colormap-View">
      <value value="&quot;Strategies&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-Num-Agents">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="*-fileIn">
      <value value="&quot;polblogsFinal.graphml&quot;"/>
      <value value="&quot;jazzFinal.graphml&quot;"/>
      <value value="&quot;emailFinal.graphml&quot;"/>
      <value value="&quot;netscienceFinal.graphml&quot;"/>
      <value value="&quot;schoolFinal.graphml&quot;"/>
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
