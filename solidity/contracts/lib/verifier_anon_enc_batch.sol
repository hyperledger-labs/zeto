// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier_AnonEncBatch {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant deltax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant deltay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant deltay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;

    
    uint256 constant IC0x = 20457956958473860293835648951879045856677043407243648302743877859875552209247;
    uint256 constant IC0y = 7776079367720380762099625163992180745418333944870070120747012066006122461055;
    
    uint256 constant IC1x = 17549927933267135940045377484490257666333216840197555674091687873774886451412;
    uint256 constant IC1y = 7777359099725353892523896849960626230014517620518326885856442970545242754330;
    
    uint256 constant IC2x = 7266608593144975111773315460187555514472943754137342878861656981647216925655;
    uint256 constant IC2y = 7636964277306973569988198676997644948196306801511281373794086341883402123046;
    
    uint256 constant IC3x = 9096435126897708624638220924873430238007027646650523572103562570436206417938;
    uint256 constant IC3y = 14049119430819940315256289700787051688993481620336037917299625578452740380713;
    
    uint256 constant IC4x = 19211209105469507152755702318350737580106120225074705315095711078638533754748;
    uint256 constant IC4y = 1437142373109547513907085005044999690512181331035758157869645400244652499489;
    
    uint256 constant IC5x = 12222905540180851820029190045981739566801977585854566585169005829892609954692;
    uint256 constant IC5y = 14549045090416232419147266612622733246416508607001040845687387258340095192145;
    
    uint256 constant IC6x = 4735648591293575660142988753722749059395263946926604330150825908832092033660;
    uint256 constant IC6y = 5187710164061334113526020240024773205825970196964734893386927402857187063177;
    
    uint256 constant IC7x = 20334714858185797595805821522541184085655033208922578178233244305037077766407;
    uint256 constant IC7y = 21884104557410710051678839643792559542224546576654807003963346710937702613433;
    
    uint256 constant IC8x = 12671237970713394931979048957648855653558007432570267806897915769288839520123;
    uint256 constant IC8y = 4028373755039302223794864114025699218021876780916423938758276516753277379453;
    
    uint256 constant IC9x = 19637480449400017323866327155419553724800176004889528445729832747387029990732;
    uint256 constant IC9y = 525358805582402449177466576244443358066620040494539217258836672038268689113;
    
    uint256 constant IC10x = 6683362214807778519679644869917831149252215801168763967482464355615388504337;
    uint256 constant IC10y = 15911582188051515386082475757956470459072857999270068218265114981181419149798;
    
    uint256 constant IC11x = 7859451747924816063864464353448322211274971735004975283586730285633565348026;
    uint256 constant IC11y = 17702245455909972873350844621328458039040233256650474440765159766665422983185;
    
    uint256 constant IC12x = 17887434247668828848829621275742692134834354053329422702672025565942351615005;
    uint256 constant IC12y = 19945940161431857227380726528931717092781378075558615731197842417099001986329;
    
    uint256 constant IC13x = 910850375080581916368615482730337187006033352469590595640777417750447607608;
    uint256 constant IC13y = 3677732807370305265286062294483845790891493712292966367578729792298898100014;
    
    uint256 constant IC14x = 11394244343739019725843491923239602248858664538230688052482501626207869677474;
    uint256 constant IC14y = 1017367602106140109792711511707675118068578981870871058707753729139351086426;
    
    uint256 constant IC15x = 17580806813370218190519612135500080594692941405328154589071627093917036218026;
    uint256 constant IC15y = 18866852522884155432837625970655651869537802178823630974722600494142936431895;
    
    uint256 constant IC16x = 20953225053977698883461234417640671125664833305435259995743410489766786811017;
    uint256 constant IC16y = 8745430177680780508827153481916758574808937829385814074304854361662865188531;
    
    uint256 constant IC17x = 9298865247055097659456332331836095871429324408895784837764325710955588923525;
    uint256 constant IC17y = 18720021835177849144326529233199949902692218020852609953397883057041365406716;
    
    uint256 constant IC18x = 9803064636763855724556507831841530068201342991085473117961961761604449353617;
    uint256 constant IC18y = 13010891856001121057287490847830065709739845170631999382717458902000410392837;
    
    uint256 constant IC19x = 21429702633296602456819134246535066068702583232025542423089522744073299522839;
    uint256 constant IC19y = 16335398909778845583628705821336521443514985762107953814101622209643140854940;
    
    uint256 constant IC20x = 9751542436554156396205960938972482822138196952556898887285337815279532559334;
    uint256 constant IC20y = 9329149151981556656299798990823114535761565475856550151911761396342936373057;
    
    uint256 constant IC21x = 14466501034453509375016805523060731169089523248364937671766094317200453715291;
    uint256 constant IC21y = 3150099584380216663313553181132841756309020309096428653543390538998378851140;
    
    uint256 constant IC22x = 16625780749334367102987241113400718766807362610198271097525872106126093250001;
    uint256 constant IC22y = 5641529405852880889432838060723510427373153385823065644704426576587683782342;
    
    uint256 constant IC23x = 10482129844561687653238400541792795523853495600910564159314860391063236893865;
    uint256 constant IC23y = 7030587236238761457314153006466652546041803446772298811234377000319902316049;
    
    uint256 constant IC24x = 17777485010211018490416436586755225220290461571556946002064191567301479196124;
    uint256 constant IC24y = 11093041903680853786134545279581284881559712502787103346113529896350026702353;
    
    uint256 constant IC25x = 8367464038675137240637235032183962189203318091597084436727361402785690352415;
    uint256 constant IC25y = 2101341872045901587244350434302489380465478959052054782990815843504622375785;
    
    uint256 constant IC26x = 9445937682034499200116555117283984556173406956968330905166247396248067476298;
    uint256 constant IC26y = 2448614491980710495634177417350604360553528335606412536811403268782338557447;
    
    uint256 constant IC27x = 9086407649402987466727626417229484253386649160044225932044624305425853693602;
    uint256 constant IC27y = 16892875124856684788049611363643986883200311062034370427528822921971214937498;
    
    uint256 constant IC28x = 19759427378006359186636323808841855999743290454170215751803319675288637666224;
    uint256 constant IC28y = 20893980529463838942352241569178910211287945093872561634827722552883873929734;
    
    uint256 constant IC29x = 20762860574071906476558223570053048914958814270667058249400227402836777574107;
    uint256 constant IC29y = 19285928520739540943739493948094407121565948163149835902863321883358878361412;
    
    uint256 constant IC30x = 12982919139442164278755036181367896103036089671229752387322345416049000267478;
    uint256 constant IC30y = 17389857939362238519664807858488982461046972261625678287174111944494040978382;
    
    uint256 constant IC31x = 9296346158583058002982031757345378508628673444232747679337799561444313658756;
    uint256 constant IC31y = 11401838933643317672245148437030692400996215400094297130676326454765266124841;
    
    uint256 constant IC32x = 17286803510413442586833249596325847372150963129796326293518898027419455799100;
    uint256 constant IC32y = 4729548357749587914597883649741039045459375769895691014012698567505454373958;
    
    uint256 constant IC33x = 6225792172100833912708432866127247904116640232886664169969642733255064660000;
    uint256 constant IC33y = 6060274113179975560638082875287670984249765738465535446839477668985817135251;
    
    uint256 constant IC34x = 16100121312513859528075023932696721282346572050314892547292307235056414188134;
    uint256 constant IC34y = 6824112582626629583841600764613110508332283077963956905469078903373189725192;
    
    uint256 constant IC35x = 11468809176406819854117038840765685383176557932415559413642626064953024788160;
    uint256 constant IC35y = 16327061741308268552699959019077558460768707604967044367693906400037465494103;
    
    uint256 constant IC36x = 5716872441568503762359414274128330720939141110087485826855142892018711170418;
    uint256 constant IC36y = 7316500402322451089160627546884883276088294973708881737262802199173885883354;
    
    uint256 constant IC37x = 9431394354834930743420189375253905724350514021300926223621405654335394524267;
    uint256 constant IC37y = 11668870674753647472543361195789115138286174053139833262874235003443925126227;
    
    uint256 constant IC38x = 14101909265881417922398903228902866393379197230150540763468879683182339922162;
    uint256 constant IC38y = 843475656712384462124393918543099201607219961246272351220447766498200318270;
    
    uint256 constant IC39x = 17242818561206755627772388888524159835848637302855005274392040904535533841946;
    uint256 constant IC39y = 12913556443462307175824182946682086865851661751785096241603862402616588100667;
    
    uint256 constant IC40x = 6664878326271511977250217125393597499868106283996944372518621978598175145743;
    uint256 constant IC40y = 15144441784853392110035931444169830357580673626108453163006810316899221105706;
    
    uint256 constant IC41x = 20086904197250387625003182009808914102381910432954527190317655483755132971479;
    uint256 constant IC41y = 9880446798565027167349769495326314796659653140515047806702697356581078693719;
    
    uint256 constant IC42x = 18568474479778525057620296750285011467433857421622424398667327542936804538421;
    uint256 constant IC42y = 14380361583263936802601888969067954059567919690190840045459166931846792356148;
    
    uint256 constant IC43x = 11544583223021191345047659621978897446635170548746961836374819427837461939803;
    uint256 constant IC43y = 20547960814800065359605548667632876088577519108660285624683924957618216127059;
    
    uint256 constant IC44x = 1912392906994463411087577566286247817866473791206599813185663829653003728024;
    uint256 constant IC44y = 13446395032386279021226716525374023030656189163839742618918207180265011638965;
    
    uint256 constant IC45x = 20845023561343448705561071146769639912487817477708421585464830888518785779848;
    uint256 constant IC45y = 20173847817888474799536463971101765819441189334369434652846457077165068620476;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[45] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            
            checkField(calldataload(add(_pubSignals, 1344)))
            
            checkField(calldataload(add(_pubSignals, 1376)))
            
            checkField(calldataload(add(_pubSignals, 1408)))
            
            checkField(calldataload(add(_pubSignals, 1440)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
