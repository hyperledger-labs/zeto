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

contract Groth16Verifier_AnonEncNullifierKycBatch {
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

    
    uint256 constant IC0x = 15409791955598787751103531970071723139038657604800305665452026264417828456151;
    uint256 constant IC0y = 9092746402899964618601098277186453924240830820427171297477612350235594762230;
    
    uint256 constant IC1x = 7949724348808454633669361647060175530323440301732291277115673476237108891542;
    uint256 constant IC1y = 18134172461804827319437762824423718348343328362280144239082682827834311228862;
    
    uint256 constant IC2x = 18412235420222622708390743487048904719675255312308900197838300506333609020567;
    uint256 constant IC2y = 3326911880786467630680443287947724677904315474829569907236338568731588390209;
    
    uint256 constant IC3x = 3684759051689549260992004811510631865027364466132862273664631251877870397322;
    uint256 constant IC3y = 4624504269022852547538527532537284583151548640246363460844851768495942507731;
    
    uint256 constant IC4x = 18939213130773768990589821900718447331875388051807136612585286320585577025449;
    uint256 constant IC4y = 9607150346436114487478754580032358572614092508303519012359064099377312258255;
    
    uint256 constant IC5x = 4304774402263129512850253862373517584669112751896010282131604467222380872267;
    uint256 constant IC5y = 3197616323427858399777352139293657890603227558000123704495239864910483658297;
    
    uint256 constant IC6x = 14968034082411198037944438376279005757480632832566654441983100737431053173139;
    uint256 constant IC6y = 3943395786320480978370375368175087409224119161587765381583492808047972463973;
    
    uint256 constant IC7x = 11811687116823296786042593031915338220372162561933438868904387374997368136764;
    uint256 constant IC7y = 16239760650134049100941091682537454263160653140559325617975183512534144672822;
    
    uint256 constant IC8x = 13976804983275936440076141436419565601451187761023120366572294561283213408400;
    uint256 constant IC8y = 15947030171848408329288205317938767625178352961026558256004543816684158607115;
    
    uint256 constant IC9x = 20091369345386756861583326092880477235913200512207815728161185428758632919068;
    uint256 constant IC9y = 4547352145684000460660484940785150198225443112294592064264306957219865903496;
    
    uint256 constant IC10x = 15110595095060568315380423877310152003500215426903188901637201624902388355156;
    uint256 constant IC10y = 13819922440260106697305874380139646513964964406997753828774348088166480904802;
    
    uint256 constant IC11x = 5945587906512448894630134998155585893626546403257902155146913990708953643745;
    uint256 constant IC11y = 15243938468151966927213881029467374776231868513060511965302481403027513458541;
    
    uint256 constant IC12x = 3872520330349265371964182773844470029034123763737284856176778645247681456330;
    uint256 constant IC12y = 821257119994220456649764245639250914434868540664111354251447828040110852279;
    
    uint256 constant IC13x = 13122105751537953478060472734571728593109791141037909305554131918806914692475;
    uint256 constant IC13y = 15292979279124357935194649187820863745461853509288265240617180128044240090657;
    
    uint256 constant IC14x = 10167782413207288301190534231562988840375951058165789141499879863754187892721;
    uint256 constant IC14y = 20283322390639552300506332669199531127947200999364059630244031764378400613094;
    
    uint256 constant IC15x = 8984567035618531287905247576065162631631871592319024551173399497889539608341;
    uint256 constant IC15y = 18269620713607175964666081043873522090762213560303588395499483649329589173645;
    
    uint256 constant IC16x = 9713414910748027054379523685487364912968107627325344557010999990578831777939;
    uint256 constant IC16y = 4692870054022375589242467164635041018867663351989965151047191078828870988721;
    
    uint256 constant IC17x = 13865899469845010484763304050002561532820628163266196179086845918095257879354;
    uint256 constant IC17y = 17571900975199411289940070705712991259136393257801761844789481862572089446647;
    
    uint256 constant IC18x = 2390580389407902207014048814252619616309527796915074314528398709506895279818;
    uint256 constant IC18y = 4969424591145852638529856130953369172440336016490171996430983061963297045302;
    
    uint256 constant IC19x = 17452028189893246532174515432652809239418123697608403429055298687480509168563;
    uint256 constant IC19y = 86359438193245786461999099825440629336828531445604585406769258431312418859;
    
    uint256 constant IC20x = 3946933204890629618761841772149162387771330690986734346980045624238048420365;
    uint256 constant IC20y = 8910516678189974356495892484074176168234708637654847928438176279314172106628;
    
    uint256 constant IC21x = 12618495222023794485338669576314609771018866125678978609149003580074546090473;
    uint256 constant IC21y = 20713404673767852598710946227524613530652582032002420042594964125130501118070;
    
    uint256 constant IC22x = 9092985967864943030084574013420756216969037396873454583653257958607237235061;
    uint256 constant IC22y = 12947543457347575920852385022907826246757887156161671231203316689150929206993;
    
    uint256 constant IC23x = 20107411386531822659805863064701617738374424337778794343309984186081206222303;
    uint256 constant IC23y = 16249927142794589636159530030849830959169064082918858812870191460154627178934;
    
    uint256 constant IC24x = 17237469442220615704547176059588037252246557986928975333149666853967593806703;
    uint256 constant IC24y = 11862548748855641235854355859509416830809770455359463411943767704841426635578;
    
    uint256 constant IC25x = 15328398666112504426405755746677020754012395476456067456627069143608266206248;
    uint256 constant IC25y = 4973042306019503096914324808310612445122399990158197046949308675346206327903;
    
    uint256 constant IC26x = 11669087226090855047491916941871948383460756475183909348701213953069422287919;
    uint256 constant IC26y = 10072778794448759237030894519386617799871409706564761609005700689132351126873;
    
    uint256 constant IC27x = 14603408206506285251954682688982168849698465419310115906252936302176631179204;
    uint256 constant IC27y = 9663651953146076173729764004629539382726994489097774005094162595670461080833;
    
    uint256 constant IC28x = 7396822726131708880917912185088971181475941912700640604595755550181705404342;
    uint256 constant IC28y = 19906765510989247741313331419663190490827813255353192539428442840624422384708;
    
    uint256 constant IC29x = 14163474333398002949552666961914368741859942634784235872206313162601575155887;
    uint256 constant IC29y = 13278320126962277105778639538474383463435654271565434594454785445205872073869;
    
    uint256 constant IC30x = 15927627966198514422070925724321570526682874834413496821335719811211151512732;
    uint256 constant IC30y = 11201407363566039528014608237609820389631499809339551547185394221538216400195;
    
    uint256 constant IC31x = 16200096381203341358770097964686539707717113982020496104150094849884172569177;
    uint256 constant IC31y = 21830618921096823302723207866940226561621821892280063231252246715709159919013;
    
    uint256 constant IC32x = 7470149472298252128273087536580334390721221485260351840130710079039352570262;
    uint256 constant IC32y = 20098326608581823320564458509312651924722414093154962128208413092515572431675;
    
    uint256 constant IC33x = 4657281324300735522985711692887039515599196293024420980624063363257088426958;
    uint256 constant IC33y = 20698165004683514087168618103711421189395745075560565692726601427834302463987;
    
    uint256 constant IC34x = 17384864280626352073519718847230379674369351290973301793123478956211736772669;
    uint256 constant IC34y = 14161685348292376953526033600445592105378491809865665700581679032619653685607;
    
    uint256 constant IC35x = 19648625233247529288604453723553767623733448237182380117534106417787880949553;
    uint256 constant IC35y = 10732198997559158875830105155626220929144961472506439906360908802485430517221;
    
    uint256 constant IC36x = 14569594836747648808206702470667318999060844339412440817715590360100710167874;
    uint256 constant IC36y = 2785158627138663820768109803275492173400792888005334555258646429679093764982;
    
    uint256 constant IC37x = 12369654625067238879916162479941781487272216649676312734708459452830833084828;
    uint256 constant IC37y = 2335402075756457462122262450966527634339550628995757706980685258964103608954;
    
    uint256 constant IC38x = 9869298631491195377875559519817256615493164909248461367549774431486593977122;
    uint256 constant IC38y = 19691463834712263324794724081276569367750111792006820801853840794626761681885;
    
    uint256 constant IC39x = 10699337988344456320696022068286842551344985572683809064365683501936978925001;
    uint256 constant IC39y = 5244923263064265795925322643256542125093480558224658910724842108581447644388;
    
    uint256 constant IC40x = 14157283479597097703499343703076655840788787450945801894031186600329232424564;
    uint256 constant IC40y = 9136157388455348072769534517178868149599822418336392627069545918450800685993;
    
    uint256 constant IC41x = 11954987635462597782331250935089282843188332910441834826349217320618588817567;
    uint256 constant IC41y = 13078511571641253398042198733440790728718539174183747094726515940254605429662;
    
    uint256 constant IC42x = 13291094562716081445366074160384218583707243478564187772879137970415619789726;
    uint256 constant IC42y = 4333894547978745599412449049000090446060773373168504945159979099761126222817;
    
    uint256 constant IC43x = 986189980794696666978691262328051729848631093468195023004451756259109980695;
    uint256 constant IC43y = 19137828594644624838178416710637283268932719030172173994449285464369025262040;
    
    uint256 constant IC44x = 12479214535049252206345099315637070711297101874505009440945943938888442635195;
    uint256 constant IC44y = 4151125701241456281849247098337429354788072144727546189249770438354773750126;
    
    uint256 constant IC45x = 947498121220943509687113538789080464820267995482387705311733146657160735113;
    uint256 constant IC45y = 3512661131761322564206050954078983364710846888810577184790815709277603813083;
    
    uint256 constant IC46x = 5429820634507503493088406800342333994457259943675439727929733206191588921862;
    uint256 constant IC46y = 3819194897596833154978213150033139255940382937907231191563543313211876861965;
    
    uint256 constant IC47x = 16147796102701069265956253724423183537210918608175999723031648726712223255669;
    uint256 constant IC47y = 4233525102295999937588548827759041455816041662451866385337511384403765725883;
    
    uint256 constant IC48x = 1972434964759191060420272054346635718432406099540931144568015514296836596349;
    uint256 constant IC48y = 4239348986409898489520160620635276475436192230474182835244095969650911061787;
    
    uint256 constant IC49x = 16670174453776185093919151472277172509144695185394414409634660533095639202608;
    uint256 constant IC49y = 9910941691566079838347163692958962776625159902756812355493455695354469743260;
    
    uint256 constant IC50x = 21689503761383362656508468344600215021312910621597797121712447473969706030630;
    uint256 constant IC50y = 18931359522444001957716791013602238947909771600416871852685531416539360492854;
    
    uint256 constant IC51x = 1053045581028280468772052630524840541103324168340705880066593288761567941190;
    uint256 constant IC51y = 4805031957228415535175850688430699295791758349486752035599631623760776555657;
    
    uint256 constant IC52x = 3409729820682150062571883903579065843125357364488386599798768489033780715862;
    uint256 constant IC52y = 7528155192774758000311673259632601533795080051149331254328030188255506567942;
    
    uint256 constant IC53x = 20565773733953661710029777125928615190879182678245724439644516050009589500357;
    uint256 constant IC53y = 16606337771290685084159805923078730402603403480864069696855253896346667164230;
    
    uint256 constant IC54x = 20196396000632374222912477070577184161045013357636416596951452501055387840596;
    uint256 constant IC54y = 119130615745090258828253056925660666538765605136045033855745758502270384818;
    
    uint256 constant IC55x = 1554035333454570805454714457986814535924120870764934624459611007817531364963;
    uint256 constant IC55y = 19456005872250053223374668164439847844382201427353212680408488920733006534045;
    
    uint256 constant IC56x = 16197160710885016337071943702127860260495530797550037958184801247867183538274;
    uint256 constant IC56y = 3617909162748976592193040040772570917617131704021515333135976780936531852121;
    
    uint256 constant IC57x = 21171872089706061238775074496252912083959910399329167060392946506322625544564;
    uint256 constant IC57y = 15429469750853406189601635469881939298010968263097525388556812664971267343537;
    
    uint256 constant IC58x = 9378009548765211514364181606941357532358035127264086470709904426766410045080;
    uint256 constant IC58y = 10346651370981083204612107140589231614149737535985302319823933023217097989759;
    
    uint256 constant IC59x = 18996155430872067620946417728532425850513726810505534253787386986496269068307;
    uint256 constant IC59y = 1408755142594437048586710739784302474437388964337188259483940686170655603527;
    
    uint256 constant IC60x = 13385732611485159295327486851012428932670667990521799954182864750292620115242;
    uint256 constant IC60y = 1511001714907675470323666335145552334204226391732329014557589274687556503565;
    
    uint256 constant IC61x = 21701689113216314563246019428304978634145146333733873239995945367677257602803;
    uint256 constant IC61y = 44927088580570472822947081302858614394027254481505983593547679667048677233;
    
    uint256 constant IC62x = 11475196756653606109330874591270742906174057636597310055108599390793179466849;
    uint256 constant IC62y = 2909832247772404653045772908856874858387637958200438038358038041972945401456;
    
    uint256 constant IC63x = 10512940413078709226778492400473407305117671666272697766334756945749206494246;
    uint256 constant IC63y = 13571836766524294823562410147524401553135629628971567220427489730413505472995;
    
    uint256 constant IC64x = 21812205546285284114323506243231064234281789295215703128258814046995921553324;
    uint256 constant IC64y = 12528762275546304661989112042817641342233832724627683716110664214409153810810;
    
    uint256 constant IC65x = 21605387708261693993604529610601858636075846833246780020614367701965894251931;
    uint256 constant IC65y = 10859490170382255901965796969712709233327722817981617040947005043088746604100;
    
    uint256 constant IC66x = 2586114672700021905596240165706407928720663014985124379010260832689549342190;
    uint256 constant IC66y = 20564285136126254906143644270813621328622572679260303315021113146236875164644;
    
    uint256 constant IC67x = 557816223758475667503128858919641573123012584186819289001824761794031299761;
    uint256 constant IC67y = 16400820552135955374838528693350227903307748491431380200598164413878657016496;
    
    uint256 constant IC68x = 9962003302079829866365704565970577480947818029867073873182705870794924486732;
    uint256 constant IC68y = 716959000882388914933224762538655976188165551854183476375289643391246291447;
    
    uint256 constant IC69x = 738121844871965010340909379074836080571797595618811934782612542148159014603;
    uint256 constant IC69y = 6343426468949982224418464814630462387404174193078749473309178803559301781097;
    
    uint256 constant IC70x = 13167993707479779370165127426150242751710752055404662483188355303007105781663;
    uint256 constant IC70y = 15998477246531512448316744240263600463820021043655199717965676772522600163726;
    
    uint256 constant IC71x = 6051615335417766776481713647012549204383170149663665671339014559712920059029;
    uint256 constant IC71y = 18777589010538084395088017111689584008610970406370754651052702787753532440510;
    
    uint256 constant IC72x = 13518484334887151051524193663558080295036405626525739476619937083329238056227;
    uint256 constant IC72y = 671272787473478304462767914757283206754162090601498675181547048922838398804;
    
    uint256 constant IC73x = 11332025574825825389045297724672678673730034743303092093812878326602363199391;
    uint256 constant IC73y = 6971500342255842346183467065934307001962360965641526536511819154882339090486;
    
    uint256 constant IC74x = 19280068923219572359617296703509567677927783956506504727438833975290284867839;
    uint256 constant IC74y = 21308462790257506549638032299804907327009994232141774767975085271035248727468;
    
    uint256 constant IC75x = 17784936271398316732546359084011581973981698020278533365131649775053958857941;
    uint256 constant IC75y = 17450624016077512334010490921302499424593775655292728145919056170764369001630;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[75] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC64x, IC64y, calldataload(add(pubSignals, 2016)))
                
                g1_mulAccC(_pVk, IC65x, IC65y, calldataload(add(pubSignals, 2048)))
                
                g1_mulAccC(_pVk, IC66x, IC66y, calldataload(add(pubSignals, 2080)))
                
                g1_mulAccC(_pVk, IC67x, IC67y, calldataload(add(pubSignals, 2112)))
                
                g1_mulAccC(_pVk, IC68x, IC68y, calldataload(add(pubSignals, 2144)))
                
                g1_mulAccC(_pVk, IC69x, IC69y, calldataload(add(pubSignals, 2176)))
                
                g1_mulAccC(_pVk, IC70x, IC70y, calldataload(add(pubSignals, 2208)))
                
                g1_mulAccC(_pVk, IC71x, IC71y, calldataload(add(pubSignals, 2240)))
                
                g1_mulAccC(_pVk, IC72x, IC72y, calldataload(add(pubSignals, 2272)))
                
                g1_mulAccC(_pVk, IC73x, IC73y, calldataload(add(pubSignals, 2304)))
                
                g1_mulAccC(_pVk, IC74x, IC74y, calldataload(add(pubSignals, 2336)))
                
                g1_mulAccC(_pVk, IC75x, IC75y, calldataload(add(pubSignals, 2368)))
                

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
            
            checkField(calldataload(add(_pubSignals, 2048)))
            
            checkField(calldataload(add(_pubSignals, 2080)))
            
            checkField(calldataload(add(_pubSignals, 2112)))
            
            checkField(calldataload(add(_pubSignals, 2144)))
            
            checkField(calldataload(add(_pubSignals, 2176)))
            
            checkField(calldataload(add(_pubSignals, 2208)))
            
            checkField(calldataload(add(_pubSignals, 2240)))
            
            checkField(calldataload(add(_pubSignals, 2272)))
            
            checkField(calldataload(add(_pubSignals, 2304)))
            
            checkField(calldataload(add(_pubSignals, 2336)))
            
            checkField(calldataload(add(_pubSignals, 2368)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
