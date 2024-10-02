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

    
    uint256 constant IC0x = 3908746068902036584695182673403181376603479880324582148825114321243612891671;
    uint256 constant IC0y = 21162112828786064616543713929918229698704770647235889713363318394799662440150;
    
    uint256 constant IC1x = 3642379909743718720667223972616632947803472137181052841764599881302381778193;
    uint256 constant IC1y = 5700062060799493168353325536337066888282356197708377158048176553718887961221;
    
    uint256 constant IC2x = 13883714266251598676630037212091956816674874202970543751742190275360370015;
    uint256 constant IC2y = 9013128711267905194310867088026059129312846054368138240183884595232062235239;
    
    uint256 constant IC3x = 3005999804264520883776168981440280516015224374225093267192929039128816329831;
    uint256 constant IC3y = 20748599987202621944902199730230404932808959329574406094906500495616797482469;
    
    uint256 constant IC4x = 19481090858272465556740330791144452263528458359409223764958298903470626687214;
    uint256 constant IC4y = 18792415692033093623283621756130887804607686318819520564109279885343725019638;
    
    uint256 constant IC5x = 12448969713894488523025375084312693267106761955829181487340902708351392804318;
    uint256 constant IC5y = 4451943501205517819821482547357035849886373691344816307731343919638734214628;
    
    uint256 constant IC6x = 17381664162004153834575790930999161722881655179006604605262793792758642679983;
    uint256 constant IC6y = 5955073198925403000259868133683281308276206242749187044627128494389698388722;
    
    uint256 constant IC7x = 7540844870141797048815373798751154886101709148125189742954623501252821997380;
    uint256 constant IC7y = 6253525261723826648073142578082080126084448733139026722678777735052950257090;
    
    uint256 constant IC8x = 19805839997705144135889984708566038603472574945344324622837596914064713396199;
    uint256 constant IC8y = 1336803162223913469717834381642344031253707528449013464685678590395405372864;
    
    uint256 constant IC9x = 18743451807103506072320740175279990367359976354617847354453015666990198214627;
    uint256 constant IC9y = 18527226988684050908269162438789430990161014050520725276204980965985853219204;
    
    uint256 constant IC10x = 20716469926257138332742504820777058284131343022612153237415866833385089623853;
    uint256 constant IC10y = 20438179848204046204482294061221996035662916929180980887567963634980416073069;
    
    uint256 constant IC11x = 6378167574020817442894921644749771291392288745723612491815802933722465022623;
    uint256 constant IC11y = 13612187135216559754197989941297002639880538077933633423488138677161003311657;
    
    uint256 constant IC12x = 15333385857097851253178637621370818801581137753864660693323273112058689282911;
    uint256 constant IC12y = 3929171055883544259875892994148070720031202423901700713626233026945678946404;
    
    uint256 constant IC13x = 5588270864149004230690874713552426810100689407611735740482460767687752844001;
    uint256 constant IC13y = 5975921942596934133040578610353947807735217388309529074679824658469199227349;
    
    uint256 constant IC14x = 17482138958808661765571534232744989982797890714926530202803582580847984111828;
    uint256 constant IC14y = 12783807925168095357228813653429913560592232717199060728813868234026459712035;
    
    uint256 constant IC15x = 2785449574867979821310147122748672312371896423551839609838567027349197532486;
    uint256 constant IC15y = 12187886123456423597181467422649464574165143241869537436961826041334507459920;
    
    uint256 constant IC16x = 5307653834074549453349104857138757249380008569841090576026761463649739707176;
    uint256 constant IC16y = 5556978340130369354792430826031648726565387972967466131395649033860118288313;
    
    uint256 constant IC17x = 6380884202734787460830258794401534351853688368379241837874778247355337094508;
    uint256 constant IC17y = 2160697878844498790334940441069541742178686519044433750614891120647951902322;
    
    uint256 constant IC18x = 11994658167418635971949537753955340743184967862844314723032425494876612243720;
    uint256 constant IC18y = 3010975013890706788598968771755991435380467529700332035057295090132482159402;
    
    uint256 constant IC19x = 18784528983632535501290508098053725269371240085820529055982172140023060191393;
    uint256 constant IC19y = 13647276251296256634937664644156826048778671296470861936367346727458948097363;
    
    uint256 constant IC20x = 19901565685179060322212685217062886072478782615405857789940282464218702015624;
    uint256 constant IC20y = 8752686505194012942840032413932954407921719670319213528230352404437455645753;
    
    uint256 constant IC21x = 4049510686026776133189723815304253783453454878162320427646942186291582655461;
    uint256 constant IC21y = 18008014605111680985940242802309637149257979280274959365104112879196086525621;
    
    uint256 constant IC22x = 3643744528885984116890759777109742229700033784333065122839897449308536196557;
    uint256 constant IC22y = 4187499643711670495859597326881223383699311901708594243258745295267681297968;
    
    uint256 constant IC23x = 20142636948800246848499978068189374630932385609008355413915058826347340990557;
    uint256 constant IC23y = 2224975576037599199629130082723271968226763768088257626452852292819197114424;
    
    uint256 constant IC24x = 4189346926624797283351494372365410510941844835138208871087521071924041718500;
    uint256 constant IC24y = 11678467025169017527080715443224734827743662587027824067762559460965643371449;
    
    uint256 constant IC25x = 2835866165380135068127599110412553728305300563836464493980711777954637073906;
    uint256 constant IC25y = 11418211775598851998087357475845197564261451852151861450865404775845026864433;
    
    uint256 constant IC26x = 6184995568126332874855666630338561271853258126973506922385207751979385498602;
    uint256 constant IC26y = 9678587807318338281788726652574496054471104584648159494751436934262734541814;
    
    uint256 constant IC27x = 15565834122743701828678116147681974875652599334101211815506693273501585368760;
    uint256 constant IC27y = 442538129585699161258548075040705114030290071054990071615328502434649120437;
    
    uint256 constant IC28x = 3192581844028425535035916103212522902617678210751909712329481309981427694695;
    uint256 constant IC28y = 875090420003136105575970258064025129997516670755032293104717805554449855436;
    
    uint256 constant IC29x = 19129803414895534287249239378206036763496633362660702877511049376065173879685;
    uint256 constant IC29y = 13476877444667980639577177516354785556257475458010264623920927454232463257207;
    
    uint256 constant IC30x = 19637362155422132622327186678387575499173188069611530140664361817836309117089;
    uint256 constant IC30y = 12746409854715557430503825810930174826627242326994531239895244410729264842917;
    
    uint256 constant IC31x = 16328912677341901807792509296560206281257420836520156102014658082160481348555;
    uint256 constant IC31y = 8459082892838654273483879375304068831177002387638017901977261066723911428821;
    
    uint256 constant IC32x = 14034854298585741434170328517907747523331147800071615806238407880893507944298;
    uint256 constant IC32y = 7677200450078323156871969319025444105783009677563714672945142925630687465585;
    
    uint256 constant IC33x = 14501072824190539624914743253079070280250538860117203479232126487148710641455;
    uint256 constant IC33y = 16167992375464116570684842429142537304944706449068534932195849898107426884478;
    
    uint256 constant IC34x = 5503113010689888257682320859656620694303594044205780087948618736092887957433;
    uint256 constant IC34y = 1696576415970418474450210124757065887772837815866971931349726049769328195003;
    
    uint256 constant IC35x = 19214195187847873310589726397831481907391292243012217437911869663034067503887;
    uint256 constant IC35y = 9805467215740856344169239336698580758111080655230710098273992409379459002166;
    
    uint256 constant IC36x = 2824456631103843669798437055745012788573969191567997729053271364215315472198;
    uint256 constant IC36y = 13210219118852365274638175699060587136493568715489361220574973518671149360830;
    
    uint256 constant IC37x = 11806481874674376764400918831538020092220367856078576427943414721863895872584;
    uint256 constant IC37y = 1126182565826373196793339854507275444810683313777655057798659711783831535129;
    
    uint256 constant IC38x = 12907395246775078964695235303299684888761112015317926640682209536722683179970;
    uint256 constant IC38y = 17810240919535582525306841683818586703251299768563907071136830231386496006481;
    
    uint256 constant IC39x = 17953909650597556894054352688798883115945121384051215064284235724397668654955;
    uint256 constant IC39y = 13868992413127277275852535983401633335127263080721107747010259640411782217018;
    
    uint256 constant IC40x = 18452672392295991040358492725963563156958402350081327237035645703595669202145;
    uint256 constant IC40y = 11005267617141936063457180323889422859839808292113083196215725053413990289581;
    
    uint256 constant IC41x = 17946873002177093051195262691330301617336977974010801103245788627534677577351;
    uint256 constant IC41y = 16139796083075326250719854294605911968674896065038419671645428862228038091678;
    
    uint256 constant IC42x = 5111397968235238332889036830227772356073950460888121488319801054320635436116;
    uint256 constant IC42y = 20126877650675869342714256575239930124479211219283818759347984503206238828307;
    
    uint256 constant IC43x = 15577716111736423524314066239481646978059221029696172444899093153756766882663;
    uint256 constant IC43y = 1882481077141013113637554586855942932004581120336227655362544837109420362087;
    
    uint256 constant IC44x = 8002207922749820785367626599773500821408568962350573677120091804299338076164;
    uint256 constant IC44y = 4349078923495179616645080177079492735428786142729957153306733080220170105442;
    
    uint256 constant IC45x = 18441600711752353062180825497817050541555822005558821568453023287455608310394;
    uint256 constant IC45y = 6416009464597275160567435185449771745423054271079755029789158059043365752903;
    
    uint256 constant IC46x = 14092536542972186697794938073105318364618372411217087001912379181513116038578;
    uint256 constant IC46y = 6915383375856867729473839705813161763964779725107660715856712463379573140538;
    
    uint256 constant IC47x = 17158487437315882139821485017999180800503814926388843639611073513525549132901;
    uint256 constant IC47y = 4429408683260349034652925083312216193990954298346463687111904624060815262917;
    
    uint256 constant IC48x = 3894268030249209499477219755529510826505048492171170075244819528783816018950;
    uint256 constant IC48y = 7624449612306353256481523141589168146964283570927922448005793884356945743541;
    
    uint256 constant IC49x = 2879903388769375388864978492549156271072122372264964992937081397289611351099;
    uint256 constant IC49y = 2293590991962647844941952134955325970988544992429589088487943316187569970984;
    
    uint256 constant IC50x = 12919709609239979981636352053788922219478857416525759799138206817584928562369;
    uint256 constant IC50y = 14836049567116014267843850012075892801447453733869024281915617688581220558191;
    
    uint256 constant IC51x = 763839195084499434891469437185541300454664672090741450855014240752484631041;
    uint256 constant IC51y = 9067748818656011510924592898496372151514937193974550909843638885339488286464;
    
    uint256 constant IC52x = 3671159513272968818143393692773242997264310034906138662167947465059141188953;
    uint256 constant IC52y = 5992372490740298946418458652958235484496577113448890395742452518043316209831;
    
    uint256 constant IC53x = 14752468970553446165055418939963620165645481039190653184028781955590932019663;
    uint256 constant IC53y = 13602415345116961361486713666845157930319884913254722970150122034256792375891;
    
    uint256 constant IC54x = 5547973682947408039996168490267734295620817217937711575875612846207168705930;
    uint256 constant IC54y = 1918514152899230992458940695194225161889379459601704182659875096307986684605;
    
    uint256 constant IC55x = 679887516886724778127471600180439877584093980737395592616133171342583758513;
    uint256 constant IC55y = 8352201394168531248618467666702687234040530811067203410289324437655297694803;
    
    uint256 constant IC56x = 17544853847589823116800694008933471467297135010824087035709723539032570705536;
    uint256 constant IC56y = 8864575927894913800601743571398347523212536745003501446294055561733569909365;
    
    uint256 constant IC57x = 2496168280855643738727620876530580168098962365131910848630447384544330182659;
    uint256 constant IC57y = 10990402612417964640564193796460901114653180089925666474012910550334812115843;
    
    uint256 constant IC58x = 10229070342672799012496852192766333061425138877942229915999360470050629255994;
    uint256 constant IC58y = 6765694676136184470134212249544791768884120464124594017266794746785806260667;
    
    uint256 constant IC59x = 15807821231740066210147893568369331798735344432795832027394420750219942185900;
    uint256 constant IC59y = 6760223102321380418036718494886836729173433114703543456433986174390102910930;
    
    uint256 constant IC60x = 14819374468504311081864250741777844866365249186097301524285476049706195166128;
    uint256 constant IC60y = 6146117414386626951125929842647069972302993155770755896539505045758996575874;
    
    uint256 constant IC61x = 17251815556152386496259216370538509798062455962341612838689196751688413591935;
    uint256 constant IC61y = 11875765802989746483881648485855343245577413942918675488651690374569095118334;
    
    uint256 constant IC62x = 20800661164952129033157405872159184314174315843329633112524517864715608206596;
    uint256 constant IC62y = 21829732780229162843374774921212052602583329914292743573368799594491352555167;
    
    uint256 constant IC63x = 21342378743798699061991894488476560795684400968203499616358951245153720325541;
    uint256 constant IC63y = 19870126064041049008134398111667610858164378394136143440856102921211634375855;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[63] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                
                g1_mulAccC(_pVk, IC51x, IC51y, calldataload(add(pubSignals, 1600)))
                
                g1_mulAccC(_pVk, IC52x, IC52y, calldataload(add(pubSignals, 1632)))
                
                g1_mulAccC(_pVk, IC53x, IC53y, calldataload(add(pubSignals, 1664)))
                
                g1_mulAccC(_pVk, IC54x, IC54y, calldataload(add(pubSignals, 1696)))
                
                g1_mulAccC(_pVk, IC55x, IC55y, calldataload(add(pubSignals, 1728)))
                
                g1_mulAccC(_pVk, IC56x, IC56y, calldataload(add(pubSignals, 1760)))
                
                g1_mulAccC(_pVk, IC57x, IC57y, calldataload(add(pubSignals, 1792)))
                
                g1_mulAccC(_pVk, IC58x, IC58y, calldataload(add(pubSignals, 1824)))
                
                g1_mulAccC(_pVk, IC59x, IC59y, calldataload(add(pubSignals, 1856)))
                
                g1_mulAccC(_pVk, IC60x, IC60y, calldataload(add(pubSignals, 1888)))
                
                g1_mulAccC(_pVk, IC61x, IC61y, calldataload(add(pubSignals, 1920)))
                
                g1_mulAccC(_pVk, IC62x, IC62y, calldataload(add(pubSignals, 1952)))
                
                g1_mulAccC(_pVk, IC63x, IC63y, calldataload(add(pubSignals, 1984)))
                

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
            
            checkField(calldataload(add(_pubSignals, 1472)))
            
            checkField(calldataload(add(_pubSignals, 1504)))
            
            checkField(calldataload(add(_pubSignals, 1536)))
            
            checkField(calldataload(add(_pubSignals, 1568)))
            
            checkField(calldataload(add(_pubSignals, 1600)))
            
            checkField(calldataload(add(_pubSignals, 1632)))
            
            checkField(calldataload(add(_pubSignals, 1664)))
            
            checkField(calldataload(add(_pubSignals, 1696)))
            
            checkField(calldataload(add(_pubSignals, 1728)))
            
            checkField(calldataload(add(_pubSignals, 1760)))
            
            checkField(calldataload(add(_pubSignals, 1792)))
            
            checkField(calldataload(add(_pubSignals, 1824)))
            
            checkField(calldataload(add(_pubSignals, 1856)))
            
            checkField(calldataload(add(_pubSignals, 1888)))
            
            checkField(calldataload(add(_pubSignals, 1920)))
            
            checkField(calldataload(add(_pubSignals, 1952)))
            
            checkField(calldataload(add(_pubSignals, 1984)))
            
            checkField(calldataload(add(_pubSignals, 2016)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
