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

    
    uint256 constant IC0x = 12699120126696616702042795693835611188938513442608634761357015044495869534559;
    uint256 constant IC0y = 8344144876820303933607569467583547699970076103074219088048430750743063413510;
    
    uint256 constant IC1x = 16416187884844297027288471132769288655520271533320369114014964168346544540099;
    uint256 constant IC1y = 1356878528531222818308966247184526360115916898839678836338456926095536339154;
    
    uint256 constant IC2x = 62377595929696134593021652643034971570500721077666972934681131078030378553;
    uint256 constant IC2y = 795051699851867226917297512137936608173384492583355182402882247080050306762;
    
    uint256 constant IC3x = 5778121379725944821697257908170619793165684439236685316571909334392687899276;
    uint256 constant IC3y = 17630593971921462955170227701775838498133145276294541260919912175629955590952;
    
    uint256 constant IC4x = 11648675848692895486398380931205112710900443013025130751120220887680971301001;
    uint256 constant IC4y = 9112971668938924276430383851378963073530364244838609886421838460341733181460;
    
    uint256 constant IC5x = 19433172173183793224443162261732029406936871437981801516259894733300324671275;
    uint256 constant IC5y = 2915093366719634833839215845233668383997328024428828942085149280931459951140;
    
    uint256 constant IC6x = 5595466263083621450560903836725049994659258503186339414406629970485916867582;
    uint256 constant IC6y = 19552530207265724629443975256194837879150213972190604620955234613515497981680;
    
    uint256 constant IC7x = 1064092098138541396472812300269891619006895953022231558798684707170217862859;
    uint256 constant IC7y = 9729512566238938916142555929136528327876358811762455691736863224135122969128;
    
    uint256 constant IC8x = 3480034825220742039321661807859539559487790944236727626343339662759175828244;
    uint256 constant IC8y = 11234719524533162198018887224755739887580346893041635195629739201452211003396;
    
    uint256 constant IC9x = 20128546724484968618373025391691635005285048004968997078102062559745538738527;
    uint256 constant IC9y = 16622117428773262357548599756037436875123188142074433076149748199874539244599;
    
    uint256 constant IC10x = 6192868544745884202867714575960488584993007452154648686652705451762021337396;
    uint256 constant IC10y = 7363064185873803843837289694577158433195395437848177254145939886170294982947;
    
    uint256 constant IC11x = 19499671436660039182126923224645466681827359494754421150222793906305268832309;
    uint256 constant IC11y = 1504156192589699581704155613080956320263905030823478823357215409776477412734;
    
    uint256 constant IC12x = 5810283581801698027066450791302740182334445425784298009106042631825936448678;
    uint256 constant IC12y = 13549533261214492083371490196814671538332418856251963243399750551613372617365;
    
    uint256 constant IC13x = 5557172463979869267861018383267755224034719297007497770145587551639958546302;
    uint256 constant IC13y = 15128771588928691820186719291881157071841015784848059733649430540846864383323;
    
    uint256 constant IC14x = 5807025266788758097546839923671472753133016173533249036682024354299181358981;
    uint256 constant IC14y = 5639889194579311603520751949731695994047088506765702571183895291116029634344;
    
    uint256 constant IC15x = 10162609175987836092783223540619402762161091070243807344151842009454415349994;
    uint256 constant IC15y = 18391215487928656682156136552562585306151369748145684180203461382068026900412;
    
    uint256 constant IC16x = 4151690490476318266796233372151034315263210679362931921371894868174179906596;
    uint256 constant IC16y = 13490485868830103570735602138780651362886666687827340823679612418156575458926;
    
    uint256 constant IC17x = 14567368626938375490503489633630652731803659155597234964733972824017995660514;
    uint256 constant IC17y = 17604576907470579907411863989543242253978919634445039770581037923252698357254;
    
    uint256 constant IC18x = 12367945773804203812958730056460709958463094211592955693369032022191192772429;
    uint256 constant IC18y = 11955892732098442171114103395643437475596988172858342209440520216362951113240;
    
    uint256 constant IC19x = 4276095971131263755704734671384505897209869999279528469847145187404938789378;
    uint256 constant IC19y = 7867228097926111735592064679006570049408362547617697035377442696578963774222;
    
    uint256 constant IC20x = 8697247021559379023821175301657654576484428929887686349347784598140983344275;
    uint256 constant IC20y = 7733952411307920955571395188496814509547872968144767087124855991198678821450;
    
    uint256 constant IC21x = 11069249984946003156922984157538148964689893528982320909760069481587218669888;
    uint256 constant IC21y = 4525904377283404280832442867774150625548954602343012113656922703708546855882;
    
    uint256 constant IC22x = 19995029879559049737140717590625727362540877795667264843249322695814476053538;
    uint256 constant IC22y = 16782912606660321995413530692120621565652252570948354564325812188511468986824;
    
    uint256 constant IC23x = 15879491562113477893492916800322788498146432217571197621178559816588987114530;
    uint256 constant IC23y = 18345243144103043831415183995976253140695546673560033918968658099441394035716;
    
    uint256 constant IC24x = 11540104220374067619892577243403073255785236378874075972793236518651277496487;
    uint256 constant IC24y = 2447150814583376335165585488011237986277384339213106095041265678329719904380;
    
    uint256 constant IC25x = 6907363068343010264119590133489740018484742849739200604819595225345777863822;
    uint256 constant IC25y = 10497272656197408725533467291802009926844236980207326224299212930278369944834;
    
    uint256 constant IC26x = 5241983233672840552357155493455034223546322711322586593362057499228586689550;
    uint256 constant IC26y = 17342107470460595815722849962358482961160523085118017854935695194746008032109;
    
    uint256 constant IC27x = 11609509237926952581278891719411603262732633897631996202688438331855735628420;
    uint256 constant IC27y = 16683132210461713295491633924865461628466075144052269471913039880797061528414;
    
    uint256 constant IC28x = 10857083459438086051349049372620002191381804158083786617214035873215380402382;
    uint256 constant IC28y = 11032806193187811193176278230374678926793237372895632232689853903462559436942;
    
    uint256 constant IC29x = 16442095169356731028245656357397228483894885673281747373520537831671678347500;
    uint256 constant IC29y = 10194336784225623186377260675151632667280228872933374130243686609999461855558;
    
    uint256 constant IC30x = 6042594869559336120559758721480656216562480694112514781612465515241783859657;
    uint256 constant IC30y = 15690364860967004757660378335551690106688797088781934710726475379872593342164;
    
    uint256 constant IC31x = 17732694366571578842559868720837058528112548067368389535938406574527136591155;
    uint256 constant IC31y = 4359611907512024893574643366872508951647492586252158534173498229222575617033;
    
    uint256 constant IC32x = 2778120878586061655655392392872489784684757293077230999948524213670268135054;
    uint256 constant IC32y = 7029550223480030453696961546180027335820067855331668166591702360338330101237;
    
    uint256 constant IC33x = 17767055144163730576178202562939832974889131269339028603191826770918243798556;
    uint256 constant IC33y = 1818684365456017483402481443072970554002760024639836215168425160231365960523;
    
    uint256 constant IC34x = 12938886031192008028421784777919205508549236431618587168013786476329699982980;
    uint256 constant IC34y = 1274880752692627174741197973146007178590877750589310612683002118807522308085;
    
    uint256 constant IC35x = 19528148884756902787793890760665720434929686084507239986978636575657409539991;
    uint256 constant IC35y = 19400448331226452208115510908379529033930093539842972440403598979706355380421;
    
    uint256 constant IC36x = 16780282682835375557250117531571256271951377548397655845278616408209361042791;
    uint256 constant IC36y = 15372350862294356096899155332858397578384657789293766279384852404791810618912;
    
    uint256 constant IC37x = 5478498176059662966773694794169465131669110633422122115374807816304240221602;
    uint256 constant IC37y = 15074772174599376522775664278048795266471337996520255985531431061181793979640;
    
    uint256 constant IC38x = 6200178978634834450304453029305448960180249591695383613629624464356325149637;
    uint256 constant IC38y = 14490933624916793439135104770495927369444863740282601420005394673073628653201;
    
    uint256 constant IC39x = 20241838623287671070830097893936952058131085715139618862611308853513207551800;
    uint256 constant IC39y = 21611284334557391098090875823180739919691042864559042568719870862030796999136;
    
    uint256 constant IC40x = 21254129275772115462470456810971062550574666839368404807554019503570322232100;
    uint256 constant IC40y = 5944922866813654488188067902812568258514133999185502944287887468006186362059;
    
    uint256 constant IC41x = 399337321031148134723747323715593967130740443573603921281423579006949142671;
    uint256 constant IC41y = 20211187410182462554359291249890939350039380739046860335937562807928109941082;
    
    uint256 constant IC42x = 11263568872993899068924935042554312931116679478846550483681421139730833692616;
    uint256 constant IC42y = 21405568442565790610225914462296754153168798276026936538920950452345368360246;
    
    uint256 constant IC43x = 2823572327618327193193372850965163553650503303469408547647576329912499453168;
    uint256 constant IC43y = 2347660115880468836079535764534295581788124330253933014147408105673089036171;
    
    uint256 constant IC44x = 10340788708034937398811280176510131265694252503810809473342169518490813155024;
    uint256 constant IC44y = 13680236879040431162592045677280925311405510993026288397049960642501926514173;
    
    uint256 constant IC45x = 6765619156941756279383837882548687039221094434606883423590352844089037361938;
    uint256 constant IC45y = 6742538488678883836036897309729718578468326745497457648591401406156874005385;
    
    uint256 constant IC46x = 16166897669018342945228620822053346072458399668346555994400248765285924022174;
    uint256 constant IC46y = 645270577003733321532731978645138370094792284442810780141862282313487597587;
    
    uint256 constant IC47x = 17796077998680558099309619969742872490037496919115499349698492850051112818792;
    uint256 constant IC47y = 18524964584367387988031317927154312757173488066745203642985493445396728590893;
    
    uint256 constant IC48x = 14103606686160945325409251295112261588748977591928739830658506596900521371039;
    uint256 constant IC48y = 1190884103334505563082115756204462501310797058962010390475165898957174931322;
    
    uint256 constant IC49x = 6188762108235943613838813976256075225617067143437912361997816760297557659768;
    uint256 constant IC49y = 14358018960628509282573113513124426414867483573390240064161023178534476179740;
    
    uint256 constant IC50x = 5010943895881112819337136285334930572902882157192747573651889986077033963320;
    uint256 constant IC50y = 15845303077989219001554232997764521993286457654994772252995069042938930988530;
    
    uint256 constant IC51x = 6675377407358434566356424878520452085552596913846786731020880338223037757746;
    uint256 constant IC51y = 720242893255427990994544475253079608079593937632594119796893849958839722715;
    
    uint256 constant IC52x = 13379318499323388188479497019098911777657013359516763895261346209992912864515;
    uint256 constant IC52y = 19566919857328823167851410345340297316210673149628893933079307108406697105821;
    
    uint256 constant IC53x = 2025377284322407301981536997201561140692075694304627248659643894144453142416;
    uint256 constant IC53y = 2598672243503327646982192757420633979044834312900891100569754705341166761956;
    
    uint256 constant IC54x = 2911252001272494516780270051061991756501735385145780178648200878858346395246;
    uint256 constant IC54y = 20058035803076597291474774733721156115546412430379924936941724795251956858015;
    
    uint256 constant IC55x = 19063528520787383609932723879262686559929150275979579698823082595934019112591;
    uint256 constant IC55y = 7013786493321495132135579985316763308255254843947287821070025355021117429762;
    
    uint256 constant IC56x = 4262640692265432276715940193363862508028087204755883178558047744705315131148;
    uint256 constant IC56y = 20337098129576165186509378213173734727792418626627477837433189535716909796279;
    
    uint256 constant IC57x = 14455424281207891418470083337897695868202900662947016302801289448824332654097;
    uint256 constant IC57y = 1798744178884627063004325311934219208267229273460796033195872754514568519543;
    
    uint256 constant IC58x = 9729118825506255517770571745702888878603373341841088470567245750076287902977;
    uint256 constant IC58y = 936451192961683933184362049802637347355330375661652800655503224090147115573;
    
    uint256 constant IC59x = 18534315685255907438497414483889964395838834854814034122326382566850420871134;
    uint256 constant IC59y = 2841084611570775011908989287704544434614599916893900012394634433223737700830;
    
    uint256 constant IC60x = 15041518511412460414265286992261357635005476768730413734804519122275789518126;
    uint256 constant IC60y = 3895778991520792118962401952066152195510121588353517590207403610703173646337;
    
    uint256 constant IC61x = 12649294487817771776508159806621989479201650038199221785764589610678571780316;
    uint256 constant IC61y = 6256906715834281346315389832320249046315376783564428723158492198241724316663;
    
    uint256 constant IC62x = 6487777734464448498210602866323353096353674869775054372552136887993811347131;
    uint256 constant IC62y = 24360379694797084595780564785876533565768666324234899928298580775411301014;
    
    uint256 constant IC63x = 5811459871973133234327550915668990695131158661382679372114885200990761930035;
    uint256 constant IC63y = 4045695106491170309243094361450114338342096314422838585974142172364681345306;
    
    uint256 constant IC64x = 2611483657848265565584944723278017183065344110990143105007822331483178800552;
    uint256 constant IC64y = 10263548862246892982805848024486855081569039368822715475306243596622125237691;
    
    uint256 constant IC65x = 12270558002016314670902881317693940006107195067120636183481536866355524557128;
    uint256 constant IC65y = 11317996337845313560238079756508290523093895311312462983939166012168975739788;
    
    uint256 constant IC66x = 15211974372459867941252491118510481033677911216380160864317747982331464374496;
    uint256 constant IC66y = 311014262165830212231580955623943734772772758555190465830242375148934819714;
    
    uint256 constant IC67x = 11457287348667220279559988020383966735691269367773904850043718904812508572322;
    uint256 constant IC67y = 6945772133716674708882877048752266677013313713995039652818289048950945779973;
    
    uint256 constant IC68x = 2199673140256479242885959096910603878584407491371548977838498847927290738836;
    uint256 constant IC68y = 16306583324722113145160725995405970205950638508755577576697645806600760307016;
    
    uint256 constant IC69x = 3551006000653499581806480534573268433884652569597466697614870801075705937752;
    uint256 constant IC69y = 8283595054277666624114901050750372656270471740913945945217909536841069217979;
    
    uint256 constant IC70x = 17138891523625603189549544667703247621904410261008458193607437285764430454445;
    uint256 constant IC70y = 17022950759803646822602687409203582219906801562094042920814525385312266052792;
    
    uint256 constant IC71x = 4389362359163225948111279701379307197183483561453258461656275420857250935964;
    uint256 constant IC71y = 18034790992414189753351208421066605221552914996224112074679860406615837533325;
    
    uint256 constant IC72x = 6349598559571409914188157594366190334953563669205590887505553505190435387133;
    uint256 constant IC72y = 39188315478664883925630083179631585828260575026149582196512064854013938590;
    
    uint256 constant IC73x = 16631036591976427553628274489263557257572467955530142387022154053157104613058;
    uint256 constant IC73y = 3074989091589258431475491704609957891001161723958823126291268993033784336702;
    
    uint256 constant IC74x = 8287610938521071787232540073914978477477086962808519884941006683469836868464;
    uint256 constant IC74y = 18849877967044258943728864913805673347634223697813193220728592340677754007378;
    
 
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
