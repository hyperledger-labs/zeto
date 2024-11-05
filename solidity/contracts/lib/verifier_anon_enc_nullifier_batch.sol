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

contract Groth16Verifier_AnonEncNullifierBatch {
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

    
    uint256 constant IC0x = 19217537801267694957539759070158122868484665020740676973199246417482535045007;
    uint256 constant IC0y = 14890590645396320527758218281502776240200960822810877247964887728574237782523;
    
    uint256 constant IC1x = 2458845034923237576954135524681777157141487752333304866768869522858381367555;
    uint256 constant IC1y = 21453325368051334210667579978214279522151243737774317389691967386465464785486;
    
    uint256 constant IC2x = 6917087986800490981289312000984454820473545909511387825804720073340917837872;
    uint256 constant IC2y = 2898048348575271793382440411949747868545552883599648380785068384524633713063;
    
    uint256 constant IC3x = 12345384099343369963411142527052659537174879997428200624260400052457757170640;
    uint256 constant IC3y = 21504026578436853050202298942786091245532679869512974657320994825847309519790;
    
    uint256 constant IC4x = 8295942885610917162774335321517534846659413408636714536059104766417496988687;
    uint256 constant IC4y = 6368926361337954845564453906009074741951993711306962274700243539769754117866;
    
    uint256 constant IC5x = 16314040942263602940727646498557453265983271018928011668882132884502482628021;
    uint256 constant IC5y = 12813594401568803290655032437000055041705798378216479550965312581114851052908;
    
    uint256 constant IC6x = 18703554633702962024743844656646257016769651037463609703447233021373021855847;
    uint256 constant IC6y = 17063635812362309846157706920614507984428768691846294091793683855011540156925;
    
    uint256 constant IC7x = 840372968238118238644593711350900108831857061727216855923803312917142738862;
    uint256 constant IC7y = 19700941462624080545496854665489742034362182494169470380957145517027978876312;
    
    uint256 constant IC8x = 21312516150647030030537136387049589816266738531033125554574448236414367632672;
    uint256 constant IC8y = 2716867834079977575870552131130700773958633314407712682964810985964916830076;
    
    uint256 constant IC9x = 4064843066946103379876227299278763710636345346922862457626244058971887111684;
    uint256 constant IC9y = 18377284634938210928923790607893095531788275023095101404541713925997515838661;
    
    uint256 constant IC10x = 6358987294878912302577825418865952112377794402728762166807736262055928962581;
    uint256 constant IC10y = 3298290856073470069604079586155864226097477393533663864387515863558767943284;
    
    uint256 constant IC11x = 6476756969881033416254545132002747825238989821869683035410765797195571077604;
    uint256 constant IC11y = 8556104489766592854854647665076480460454491377088200406873587420779663178793;
    
    uint256 constant IC12x = 21604235171203640567425754182130744234178874507423755278922305676842742843355;
    uint256 constant IC12y = 10019749963276411427163563602488490499882481121214999757469160360964302290204;
    
    uint256 constant IC13x = 4187548419108484620829850058776572334742111454307714273136133270391063262690;
    uint256 constant IC13y = 8803535773688355710704662331874792080312880250113405726628363303362404210442;
    
    uint256 constant IC14x = 2724351901936809885614843514953009165676898457017440586615215550329523429130;
    uint256 constant IC14y = 3368198594829198216248681522021512854394824385929923522583668760257697634106;
    
    uint256 constant IC15x = 7378101059384478788462514573762863508787606558656596446392749157424064991942;
    uint256 constant IC15y = 20365236435755744362605904963444568085097472381165115361346069794340503862197;
    
    uint256 constant IC16x = 12790442221582748012451695720414604697801006998784779782845049003170818060402;
    uint256 constant IC16y = 17603456025706177607512042782490147335916336584240042971857535331833823950042;
    
    uint256 constant IC17x = 3851842572866308712169846424919702445894635560335596440046845671710687956873;
    uint256 constant IC17y = 12575879180998918402386482413203350105509847147526490174314817605412191061272;
    
    uint256 constant IC18x = 8849435654982866896647119963125322358030272956082548156086095981537278402215;
    uint256 constant IC18y = 8034939600018738334841503124976442110938047409001051764237872353304629439573;
    
    uint256 constant IC19x = 18098810952343365559798635927128628598335631103437358237740844025722222351622;
    uint256 constant IC19y = 16516180718424763548403377389225345087624883654095186741396600620463428312767;
    
    uint256 constant IC20x = 6579364091033795363462966653813241981708732427900703745748034276632608355973;
    uint256 constant IC20y = 14794965607927550649559984092472123446636534647123626827149760345662038545010;
    
    uint256 constant IC21x = 3001451431393088702170324146257904202930168436525194360056543452632359790122;
    uint256 constant IC21y = 12501351513042157063508255457220643676836352019579114665236573188863643453886;
    
    uint256 constant IC22x = 11942247410949004404416485453875658924229030720592874191561708421687629514577;
    uint256 constant IC22y = 1421248357425203037573163623680169679950216475163430615222441389511611293589;
    
    uint256 constant IC23x = 5924552212616721590180004751104062729971995774011665978090652907729492407690;
    uint256 constant IC23y = 17648544619305644385179861819278423699351610190370302302782680895192029612411;
    
    uint256 constant IC24x = 3852410005009552403509723499950390111200939181225189955073499776801882057859;
    uint256 constant IC24y = 6146695597909031860519291933903293536528249979898513663021242312319464941810;
    
    uint256 constant IC25x = 9247616232285400811073826135240721400561648775034940006093158219534855129985;
    uint256 constant IC25y = 2640261489836069291278916115064522602809250287607948726708988444431435707457;
    
    uint256 constant IC26x = 7678048002991743186727896008179101418130527872753399751743968425005524398965;
    uint256 constant IC26y = 3392574415890546585317056513324401263410990249247954196241198242445003365560;
    
    uint256 constant IC27x = 7741508021482922248975388162348352525531294316776044025278749458052049431092;
    uint256 constant IC27y = 10061313902955383668088273855929795857089646056508670980726293954854402737420;
    
    uint256 constant IC28x = 6562691754111202415666082753816979207691468080205131183924439567347912902869;
    uint256 constant IC28y = 6344532931998717993276744252241201010738794788325943472038713989071390084516;
    
    uint256 constant IC29x = 8705383044247372786727225245213936989481335408510379605597943655773592769897;
    uint256 constant IC29y = 4633017540698505878365628680201009868479635214348267338676926045606388125469;
    
    uint256 constant IC30x = 17964342555248266235202549979909032885652363928372682447189601453029594350713;
    uint256 constant IC30y = 8291352501386608509191006020538912622590188422694048221796733835140743075846;
    
    uint256 constant IC31x = 21273852284702995833408839626629633436749858568256501644701951962582811103262;
    uint256 constant IC31y = 18953474452989593494992379158383489987955115902236814560897478376687604683021;
    
    uint256 constant IC32x = 15999826966013580868113696432513390266704706616728089191411249704708154774986;
    uint256 constant IC32y = 5675893162769614267097674220991526257258036763497879884263724290538034643054;
    
    uint256 constant IC33x = 3053982756385888224231620837863918518883907052505512798602177492692753505528;
    uint256 constant IC33y = 38547646871469253723790967403953954342325053602252665195841575248185579548;
    
    uint256 constant IC34x = 12290750332906620508786394826438786658461811128724285564358419882473318286055;
    uint256 constant IC34y = 20649236855344307101945108639728064898260245272725874780398298925947407720180;
    
    uint256 constant IC35x = 21123277002588670947416467083386366326312832649485763973013785814255532697733;
    uint256 constant IC35y = 16425986861789429560479145822445086165103201837072576944155696376984831394175;
    
    uint256 constant IC36x = 14698906939955789456115142981511156655482438724705493194693611836575602047678;
    uint256 constant IC36y = 975221092168539271608327236217704450964028529427964579813238090638259553377;
    
    uint256 constant IC37x = 12985962913023133640351315427038039610315448708895624766001624807948877636047;
    uint256 constant IC37y = 11734463998145696188744527813773539917622566641019599993641061593724680895935;
    
    uint256 constant IC38x = 16077998580926314769184160977531197959561228848820808224824825019538872269812;
    uint256 constant IC38y = 18051517238082980446564317606673452928213736670021543630324769387851605043481;
    
    uint256 constant IC39x = 5085977842284545822563309622556575720986115090525139685880730298447345055166;
    uint256 constant IC39y = 15311248373785821204569961460772002221139957541676255135805267426000258183098;
    
    uint256 constant IC40x = 20051155217605155286508416252077900886938393222358119831160001945498863388113;
    uint256 constant IC40y = 17264960727921200755357029820669712450505626133576443715913677414615924541235;
    
    uint256 constant IC41x = 648220535908114594443973984467321684783032250050570230192148754952591423800;
    uint256 constant IC41y = 188877397589030783635473413404716191633392400171919152156873972393897459450;
    
    uint256 constant IC42x = 19439662478625208054902315420607333969867046011068148467370996816524965653232;
    uint256 constant IC42y = 2333640222842586397570878422839337046915190766331506141848065607790831798373;
    
    uint256 constant IC43x = 5188766875169466268045643524405834185741243372869014932440825081276229198653;
    uint256 constant IC43y = 2317853041616684816904015956385433643027447639206890165338816957405649038623;
    
    uint256 constant IC44x = 1458891349966087469903345439317648653744547511523311007393705623293780183769;
    uint256 constant IC44y = 6666818570811324550227488402552271031329814753688251317599700512260023127154;
    
    uint256 constant IC45x = 8533296678862895828338136497193360591760708003725926933253048343989340457424;
    uint256 constant IC45y = 14266794324333419101000813404158573121491569817153679476936361551889805993654;
    
    uint256 constant IC46x = 3400328967031464736674306624816381095619778236004942533658937507475094309512;
    uint256 constant IC46y = 8730747781417225922242078398629922467737962158095382688689820097274561548979;
    
    uint256 constant IC47x = 5901595094199181074567126796958274204681354255285842611531902927431839563045;
    uint256 constant IC47y = 13729275504663757937866220834341628104143067447179879648229365011602613176935;
    
    uint256 constant IC48x = 13487698366490852429804211493291156834624486082910984772199445696354126191885;
    uint256 constant IC48y = 21820432862734873270317526132706662960324128442688220457497099344839239892164;
    
    uint256 constant IC49x = 966314658444985962080073829511193349975328779552440119074483222790878019291;
    uint256 constant IC49y = 7904258038244593708102681608752174098891875374638683520583075451222169910307;
    
    uint256 constant IC50x = 13769688069719349639785981513026022567584600172718207771564162745119660680122;
    uint256 constant IC50y = 8131498970452788922855730012266571576416986889997168860462922535207464272985;
    
    uint256 constant IC51x = 9221027708572641094642198526145897693505390704440277544000014085275385777726;
    uint256 constant IC51y = 13934559619024992734828462544673950804786185494248438646536254878035441136115;
    
    uint256 constant IC52x = 15156627858116432455754635593951997695631362081699255265656991022292960956121;
    uint256 constant IC52y = 5247536538904900799072671874044308141855717831447159015450376550116893900879;
    
    uint256 constant IC53x = 8128171284741297453475773678120264018027378030869583849845111087061883953194;
    uint256 constant IC53y = 12000928049978373790088680332328420144989299979646264454602229582991230713492;
    
    uint256 constant IC54x = 15079635714503317031973915832729692812962912856762722419745941123850965536791;
    uint256 constant IC54y = 21219107267885063520580299025823809517880318906241324857750648574137733612340;
    
    uint256 constant IC55x = 9494156304963239502207832089831077864467903896930269903800292651917427689444;
    uint256 constant IC55y = 13732102823676963465083178968006676561506100136400103355523367591485264947612;
    
    uint256 constant IC56x = 15725786826657159747239546675245355959463253032973650442448952039647852938718;
    uint256 constant IC56y = 11086188316379646892279919031720947393848949611877519723340855927880098859389;
    
    uint256 constant IC57x = 6022539567005437498329575316925887584040231525921806601357916463529311307212;
    uint256 constant IC57y = 19179148285874051938849777846085488029038318448103930459513498581622496936069;
    
    uint256 constant IC58x = 18071480336868436915359269781322510273691531539311458086889730984277721296864;
    uint256 constant IC58y = 18966498307005607948781996622229320906038968390589129447132977189611127813651;
    
    uint256 constant IC59x = 16017362686662403790539414408243747388402925985317246436474695569820871269465;
    uint256 constant IC59y = 8500761837364009128331103353474525767169254015355264942031458205667202760951;
    
    uint256 constant IC60x = 1937487277591680597529110893586460394469956696335093283874375245129173046751;
    uint256 constant IC60y = 7101354064287115636210837776391536170534348803369963873194459103232701994769;
    
    uint256 constant IC61x = 19366584965429936247820553821438585192984789634187034808964374250685234735626;
    uint256 constant IC61y = 2693953064018529936351531397034115491874610594137483108544480330535304183798;
    
    uint256 constant IC62x = 9796473696919008955827591474495225418750253704118837496743963336574921640578;
    uint256 constant IC62y = 2548493387538352789957819301393219498749894435136915455294867987570211459363;
    
    uint256 constant IC63x = 20914181116691637628356239632260756140107819585830692547540251648627306876947;
    uint256 constant IC63y = 18193055360643075682030719112290817667688065559588647625933701213543109219341;
    
    uint256 constant IC64x = 7590544337925632858337703020484221426132530839408281128179449974509873136195;
    uint256 constant IC64y = 11510422584723144323919923613436548509909070940413652504729783865359730971822;
    
    uint256 constant IC65x = 4694595174920417145999318050692157482516422041538284671744267152197190184056;
    uint256 constant IC65y = 14646520880631007007009774542720818216865704430422186739272391059676402537358;
    
    uint256 constant IC66x = 5750409931917473308612899156998709773165015643269441018229698554652110642175;
    uint256 constant IC66y = 19034109253789514931417768471140326722247669287014078330926534975310228981090;
    
    uint256 constant IC67x = 15390918806264582184650091883144908610359964197891913006598326586341853675304;
    uint256 constant IC67y = 13439160594524324361897920652879947408058886302898107189111019940491972950354;
    
    uint256 constant IC68x = 11271968681168106352400768936464218756552268568378701359612036307621530181332;
    uint256 constant IC68y = 635767303573027732344745665074069540634679062776755065710280646241068994918;
    
    uint256 constant IC69x = 10736076526117844410735718604166158280597244449310755846026905268731124345826;
    uint256 constant IC69y = 20807204501960218086586261763683268384925061601299143804857767694209430419479;
    
    uint256 constant IC70x = 13901637602769916482888071949588465266686306988116494868759968742559995405307;
    uint256 constant IC70y = 2496523045035897531774912715838836013115381118752269988037140812048932391857;
    
    uint256 constant IC71x = 6367875846303037853932848737947083266057737936293301564611486871329920676947;
    uint256 constant IC71y = 14252258147708194343097733785952582749473737908619421429097120842792104856742;
    
    uint256 constant IC72x = 20955042125018245317266968455002992788063486264679944602284564158925998036281;
    uint256 constant IC72y = 12079781019146299255718171718547557703530548470861277971724323693482661092037;
    
    uint256 constant IC73x = 11241323371380716059386068725352546279646106877953502115885101918331471384288;
    uint256 constant IC73y = 1703189593817285709253120674471927818433481193872510089328883692981651861981;
    
    uint256 constant IC74x = 7288855629888996777040435802759971313675228158845935165000074201444128511193;
    uint256 constant IC74y = 12505414715511075904897977739556530242040982357119163432484592429166870641050;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[74] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
