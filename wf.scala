
val fileName = Val[String]
val topology = Val[String]
val numAgents = Val[Double]
val connectionProbability = Val[Double]
val initialNeighbours = Val[Double]
val rewiringProbability = Val[Double]
val scaleFreeExponent = Val[Double]
val initialRandomTypes = Val[Boolean]
val initialMaxi = Val[Double]
val initialMini = Val[Double]
val initialConf = Val[Double]
val strengthOfDilemma = Val[Double]
val inicoop = Val[Double]
val replacement = Val[Boolean]
val culturalConstant = Val[Double]
val loadtopology = Val[Boolean]
val seed = Val[Int]
val maxi = Val[Double]
val graph = Val[File]
val coop = Val[File]
val popul = Val[File]
val ages = Val[File]

val exploration = 
  ExplorationTask(
    (rewiringProbability in (0.0 to 1.0 by 0.01)) x
    (inicoop in (0.0 to 100.0 by 0.05)) x
    (strengthOfDilemma in (0.0 to 0.5 by 0.05)) x  
    (seed in (UniformDistribution[Int]() take 100)) take 5
  ) 

val cmds = List(
  "random-seed ${seed}",
  "run-to-grid 50",
  "export-graph",
  "export-coop",
  "export-prop",
  "export-ages"
)
  
val basePath = "/iscpif/users/sifuentes/"

val model = 
  NetLogo5Task(basePath + "metamimetic/model/OM_Metamimetic_Networks.nlogo", cmds, true) set (
    inputs += seed,
    fileName := "file",
    topology := "Small-World",
    numAgents := 500.0,
    connectionProbability := 0.5,
    initialNeighbours := 8,
    scaleFreeExponent := 2,
    initialRandomTypes := true,
    initialMaxi := 0,
    initialMini := 0,
    initialConf := 0,
    replacement := true,
    culturalConstant := 1.0,
    loadtopology := false,
    netLogoInputs += (fileName, "file.name"),
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
    netLogoOutputs += ("maxi", maxi),
    outputFiles += ("graph.graphml", graph),
    outputFiles += ("popul.csv", popul),
    outputFiles += ("coop.csv", coop),
    outputFiles += ("ages.csv", ages),

    outputs += (rewiringProbability, inicoop, seed, strengthOfDilemma)
  )

  
val csvHook = AppendToCSVFileHook(basePath + "output/result/result.csv")

val fileHook = CopyFileHook(graph, basePath + "output/graphs/graph_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}.graphml" )

val populHook = CopyFileHook(popul, basePath + "output/plots/popul_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}.csv" )

val coopHook = CopyFileHook(coop, basePath + "output/plots/coop_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}.csv" )

val agesHook = CopyFileHook(ages, basePath + "output/plots/ages_${rewiringProbability}_${inicoop}_${seed}_${strengthOfDilemma}.csv" )

val env = EGIEnvironment("vo.complex-systems.eu")

val ex = exploration -< (model   hook ( csvHook , fileHook , populHook , coopHook, agesHook) ) start
