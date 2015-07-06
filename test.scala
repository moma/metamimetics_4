


val numAgents = Val[Double]
val topology = Val[String]
val strengthOfDilemma = Val[Double]
val inicoop = Val[Double]
val replacement = Val[Boolean]
val culturalConstant = Val[Double]
val loadtopology = Val[Boolean]
val filein = Val[String]
val seed =  Val[Int]
val connectionProbability = Val[Double]
val initialNeighbours = Val[Double]
val rewiringProbability = Val[Double]
val scaleFreeExponent = Val[Double]
val initialRandomTypes = Val[Boolean]
val initialMaxi = Val[Double]
val initialMini = Val[Double]
val initialConf = Val[Double]
val graph = Val[File]
val coop =  Val[File]
val popul = Val[File]
val ages =  Val[File]


val exploration = 
ExplorationTask (
    (seed in (UniformDistribution[Int]() take 10 ))x
    (rewiringProbability in (0.0 to 1.0 by 0.01)) x
    (initialNeighbours in List (25.0 , 50.0 , 75.0))x      
    (SobolSampling(
    200,
    strengthOfDilemma in Range(0.0 , 0.5),
    inicoop in Range (0.0, 100.0)
    ))take 10)
 

val cmds = List(
  "random-seed ${seed}",
  "run-to-grid 500",
  "export-graph",
  "export-coop",
  "export-prop",
  "export-ages"
)
  
val basePath = "/iscpif/users/sifuentes/"




val model = 
  NetLogo5Task(basePath + "metamimetic/model/OM_Metamimetic_Networks.nlogo", cmds, true) set (
    inputs += seed,
    topology := "Small-World",
    numAgents := 500.0,
    connectionProbability := 1.0,
    filein := "inicoop", 
    scaleFreeExponent := 2.0,
    initialRandomTypes := true,
    culturalConstant := 1.0,
    initialMaxi := 0,
    initialMini := 0,
    initialConf := 0,
    replacement := false,
    loadtopology := false,
    netLogoInputs += (filein, "FileIn"),
    netLogoInputs += (topology, "Topology"),
    netLogoInputs += (numAgents, "Num-Agents"),
    netLogoInputs += (connectionProbability, "Connection-Probability"),
    netLogoInputs += (initialNeighbours, "Initial-Neighbours"),
    netLogoInputs += (rewiringProbability, "Rewiring-Probability"),
    netLogoInputs += (scaleFreeExponent, "Scale-Free-Exponent"),
    netLogoInputs += (initialRandomTypes, "Initial-Random-Types?"),
    netLogoInputs += (initialMaxi, "Initial-Maxi-%"),
    netLogoInputs += (initialMini, "Initial-Mini-%"),
    netLogoInputs += (initialConf, "Initial-Conf-%"),
    netLogoInputs += (strengthOfDilemma, "Strength-of-Dilemma"),
    netLogoInputs += (inicoop, "inicoop"),
    netLogoInputs += (replacement, "replacement?"),
    netLogoInputs += (culturalConstant, "cultural-constant"),
    netLogoInputs += (loadtopology, "Load-Topology?"),    
    outputFiles += ("graph.graphml", graph),
    outputFiles += ("popul.csv", popul),
    outputFiles += ("coop.csv", coop),
    outputFiles += ("ages.csv", ages),
    outputs += (rewiringProbability, inicoop, seed, strengthOfDilemma, culturalConstant , initialNeighbours, filein)
  )
  

val fileHook = CopyFileHook(graph, basePath + "metamimetic/output/graphs/graph_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}_${culturalConstant}_${initialNeighbours}_${filein}.graphml" )

val populHook = CopyFileHook(popul, basePath + "metamimetic/output/plots/popul/popul_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}_${culturalConstant}_${initialNeighbours}_${filein}.csv" )

val coopHook = CopyFileHook(coop, basePath + "metamimetic/output/plots/coop/coop_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}_${culturalConstant}_${initialNeighbours}_${filein}.csv" )

val agesHook = CopyFileHook(ages, basePath + "metamimetic/output/plots/ages/ages_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}_${culturalConstant}_${initialNeighbours}_${filein}.csv" )

val env2 = EGIEnvironment("vo.complex-systems.eu")
val env4 = EGIEnvironment("vo.lal.in2p3.fr")
val env3 = LocalEnvironment(4)

val ex =  exploration  -< (model    hook ( fileHook , populHook , coopHook, agesHook) on env4 by 10)  start



