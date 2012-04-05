import static org.openmole.core.implementation.data.Prototype.*
import org.openmole.core.implementation.data.*
import org.openmole.plugin.task.systemexec.*
import org.openmole.plugin.task.netlogo4.*
import org.openmole.plugin.task.groovy.*
import org.openmole.plugin.sampling.combine.*
import org.openmole.plugin.domain.range.*
import org.openmole.plugin.domain.collection.*
import org.openmole.plugin.domain.distribution.*
import org.openmole.plugin.hook.display.*

import org.openmole.core.implementation.sampling.Factor
import org.openmole.plugin.sampling.complete.*

import org.openmole.core.implementation.task.*
import org.openmole.plugin.task.serialization.*
import org.openmole.plugin.hook.filemanagement.*
import org.openmole.core.implementation.transition.*
import org.openmole.core.implementation.mole.*
import org.openmole.plugin.hook.file.*

result='/home/erick/OpenMOLE/results/'
script= new File('/home/erick/OpenMOLE/test_smallworld.nlogo')

output = new Prototype("output", Double)
output1 = new Prototype("output1",Double)
output2 = new Prototype("output2",Double)
output3 = new Prototype("output3",Double)
output4 = new Prototype("output4",Double)

seed = new Prototype("seed", Integer)
strength_of_dilemma = new Prototype("strength_of_dilemma", Double)
inicoop = new Prototype("inicoop",Integer)
rewiring_probability= new Prototype("rewiring_probability",Double)
num_nodes= new Prototype("num_nodes",Integer)

seedFactor = new Factor(seed, new UniformIntDistribution(1L))
strengthFactor = new Factor(strength_of_dilemma, new DoubleRange("0.0","0.4","0.1"))
inicoopFactor = new Factor(inicoop, new IntegerRange("0","100","10"))
//strengthFactor = new Factor(inicoop, new ValueSetDomain("0.05","0.1","0.15","0.2","0.3","0.4"))
rewireprobFactor = new Factor(rewiring_probability, new DoubleRange("0.0","1.0","0.01"))
agentsFactor = new Factor(num_nodes, new IntegerRange("10","120","10"))
 
// Define the exploration task
plan = new ReplicationSampling(new CompleteSampling(strengthFactor,inicoopFactor,rewireprobFactor,agentsFactor), seedFactor, 10)
//plan = new ReplicationSampling(new CompleteSampling(strengthFactor,inicoopFactor,rewireprobFactor), seedFactor, 10)
exploration = new ExplorationTask("exploration", plan)
explorationTC = new Capsule(exploration)
 
cmds = ['random-seed ${seed}','setup', 'repeat 10 [ go ]']
 
// NetLogoTask constructor, which contains:
// - the path to the nlogo scripts,
// - the command list
netLogoT = new NetLogo4Task("NetLogoTask",
                            script,
                            cmds)
// NB : addNetLogoInput(name_of_input_var) or
// addNetLogoOutput("name_of_netlogo_global_variable_or_reporter",name_of_output_var)
// permit to import or export variable of NetLogo execution context
// ( be careful to not overwrite existing variable !)
netLogoT.addInput(seed)
netLogoT.addNetLogoInput(strength_of_dilemma)
netLogoT.addNetLogoInput(inicoop)
netLogoT.addNetLogoInput(rewiring_probability)
netLogoT.addNetLogoInput(num_nodes)
netLogoT.addNetLogoOutput("cooperation-rate",output)
netLogoT.addNetLogoOutput("maxi",output1)
netLogoT.addNetLogoOutput("mini",output2)
netLogoT.addNetLogoOutput("conf",output3)
netLogoT.addNetLogoOutput("anti",output4)
netLogoT.addOutput(seed)
netLogoT.addOutput(strength_of_dilemma)
netLogoT.addOutput(inicoop)
netLogoT.addOutput(rewiring_probability)
netLogoT.addOutput(num_nodes)
netLogoTC = new Capsule(netLogoT) 

swn1 = new Prototype ("swn1", File)

storeTask = new StoreIntoCSVTask("storeTask",swn1)
storeTask.addColumn(strength_of_dilemma.toArray(strength_of_dilemma))
storeTask.addColumn(inicoop.toArray(inicoop))
storeTask.addColumn(rewiring_probability.toArray(rewiring_probability))
storeTask.addColumn(num_nodes.toArray(num_nodes))
storeTask.addColumn(output.toArray(output))
storeTask.addColumn(output1.toArray(output1))
storeTask.addColumn(output2.toArray(output2))
storeTask.addColumn(output3.toArray(output3))
storeTask.addColumn(output4.toArray(output4))
storeTaskCapsule = new Capsule(storeTask)

new ExplorationTransition(explorationTC, netLogoTC)
new AggregationTransition(netLogoTC,storeTaskCapsule)

exG = new MoleExecution(new Mole(explorationTC))

new CopyFileHook(exG,storeTaskCapsule,swn1,result + 'swn1.csv')
new DisplayHook(exG, netLogoTC, ' ${strength_of_dilemma}, ${inicoop}, ${rewiring_probability}, ${num_nodes}')

exG.start() 

