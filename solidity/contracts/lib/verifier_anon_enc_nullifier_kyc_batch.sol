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

    
    uint256 constant IC0x = 10313937918103006087784866174735853954689221521812327103378704235802781783561;
    uint256 constant IC0y = 9753072327140341857940641496334056679207002439635188121425876053327397284465;
    
    uint256 constant IC1x = 10837018114391433120066015637353051698266626985828802127041804457099401290031;
    uint256 constant IC1y = 2982163603577493555221849060777390590811896936712935986581972594710386755515;
    
    uint256 constant IC2x = 15809818997500549555531508977476359226600004177863142328042033014949187765336;
    uint256 constant IC2y = 893697954977294279712866797222407064519597900874144269386491184084637152910;
    
    uint256 constant IC3x = 1760167260149703624757217835400479055600992852300456860337917837942892262759;
    uint256 constant IC3y = 20185909825956660798417393594301342013466827979188768761589718996617773511457;
    
    uint256 constant IC4x = 10691882895398275550900655832910996988739466960548192244571784986487873504768;
    uint256 constant IC4y = 14211404856310758390589849011530823993198346442063943305477292273161422898263;
    
    uint256 constant IC5x = 2773130435727965146080581237546937160598623793132633421477533527595027153051;
    uint256 constant IC5y = 20810657347524001161653585450420346285370517508265877765700441062076754600077;
    
    uint256 constant IC6x = 1161242845389465429766318711786895320969461646902204275121439410269004471138;
    uint256 constant IC6y = 18454796860018756806404816055138940543472952037712966637529624926504184509171;
    
    uint256 constant IC7x = 4248017624475625144715690241478466683332800508897801986353687509024604901793;
    uint256 constant IC7y = 6122123222639915863223012216736054719278693831923872494251923475579926931951;
    
    uint256 constant IC8x = 13702868573978162176569367782261488955675128368488232675020348346841145417649;
    uint256 constant IC8y = 401950476018843796662444151014082486929844430835241644670932038434554699242;
    
    uint256 constant IC9x = 9295528819539531989370128536259187619076160101891771892284414452546586024325;
    uint256 constant IC9y = 14024992635014569270076190441387074919891155775520316921658035972640774022153;
    
    uint256 constant IC10x = 14651518724159534834865763954533532100335352773559846970214783908239631060004;
    uint256 constant IC10y = 14716291061967925702256622117534751697918787244601125408716130783518619404154;
    
    uint256 constant IC11x = 897066394608916572506480662684479167375023594931057409678688013532607794469;
    uint256 constant IC11y = 10097224282069070967294119398237082236327606621329527219351408735954090900594;
    
    uint256 constant IC12x = 13137335621153465871927007841510867610970534834965566541496320309067913014991;
    uint256 constant IC12y = 13767457955744567466456543725605066192141100331853456918050474254564570906320;
    
    uint256 constant IC13x = 9185063127824805938140034226708029248503889236459251654915117260419716651906;
    uint256 constant IC13y = 294265216701767923839288271762897793399575912527132858100455857234841719930;
    
    uint256 constant IC14x = 20085932004072708607054119141829894114919994114571635227359304685166480261595;
    uint256 constant IC14y = 2118139544423683694402644389169914385791748478903198871842020532666042669100;
    
    uint256 constant IC15x = 4887650394951202709891616362236402801333441619841654173661248101656314090253;
    uint256 constant IC15y = 14907739530638999243456819634668087350467018399995057982143890060442809743822;
    
    uint256 constant IC16x = 831789844018467110564529285981118438766993460808608012864871642227448711395;
    uint256 constant IC16y = 19096168764998021971355082100591441985982815076224212464951175587180889872830;
    
    uint256 constant IC17x = 1208505121302057171020675426556633291369342700439558144299973455671196838640;
    uint256 constant IC17y = 6175547253764411855411324283563965478122004378396766171641686695612924647544;
    
    uint256 constant IC18x = 705815259856478504599910681434122344166939385201234589611934664029642219852;
    uint256 constant IC18y = 14804076456123822871277956563749577226773235274203708508893406009369381931813;
    
    uint256 constant IC19x = 7806882928722465088107601788618158485382274393316220103389925942002851962259;
    uint256 constant IC19y = 8592196309012296147907691414616176025419819257905158585826427513529836835686;
    
    uint256 constant IC20x = 12659686801893070697535063125683773487303137847017519696015864622636505540559;
    uint256 constant IC20y = 2803624389949775226020660108586362141564188093277775484507817112369201850239;
    
    uint256 constant IC21x = 4173082474247027947087164776964754352022620830671173849255306030963578743875;
    uint256 constant IC21y = 13069857466013971555026273686601123384113982180009177354512065772031416485737;
    
    uint256 constant IC22x = 15147505627892888628906150579619225365550496373644892686880583066036162566090;
    uint256 constant IC22y = 21181854477929617880426505403726773669270295004795649186884663042368536585805;
    
    uint256 constant IC23x = 18863705946802530900553225268001444866806197021236439401354970713406189145054;
    uint256 constant IC23y = 4127867810445089250563993892543154876702695395769270442714195676610603494135;
    
    uint256 constant IC24x = 15397639017612493934063704442563213431518425591666183369626428553085464859163;
    uint256 constant IC24y = 4291106754091108077823000816574790575263904072011853641461379425441455621847;
    
    uint256 constant IC25x = 17390132629707385928815064735308457125475727726167446507030805170842650394508;
    uint256 constant IC25y = 20896763419196123991227196403983663132656893264515803340809573675452852379568;
    
    uint256 constant IC26x = 13461271829631669834803539751137343159004542874559195748823092118270201084724;
    uint256 constant IC26y = 2729008404271921836123381319633233755724309244741467349445146889554365572892;
    
    uint256 constant IC27x = 14602311746837159687451204187512146002846595010836650318097447380356135380378;
    uint256 constant IC27y = 7720727360532787685375360924388144433072408339548663818312006584369927773425;
    
    uint256 constant IC28x = 229483178419198916081647047738959261404423763621132035795810306367615982383;
    uint256 constant IC28y = 10370672370162120462305012942875922874382588812317371373171701200828836513722;
    
    uint256 constant IC29x = 9544668441293238664559124142133075724287352756990702009122269905175679249518;
    uint256 constant IC29y = 7638805138093117181142650576991676543320895935868430181584310124648966125944;
    
    uint256 constant IC30x = 20074876114417271748711207825247144768633410292828524920700988903690315408490;
    uint256 constant IC30y = 6892589013608461855020275071724097064741310157307567806016718681380787653203;
    
    uint256 constant IC31x = 13906178102146977145526538118887437955796790170333149837477330438577620407095;
    uint256 constant IC31y = 9681348012621238562403882464494819950616528879027381711013987832201952273033;
    
    uint256 constant IC32x = 18119439025312924276714212538961039679573737576000491440803052958595635807660;
    uint256 constant IC32y = 8663052687644818519156046549466328762101970713600442063692688469854959385377;
    
    uint256 constant IC33x = 1962788241364829969215672359881468784221059289045840900001773618114783221518;
    uint256 constant IC33y = 13590518782283443971098101772742986683657333997545134243755191767962819021944;
    
    uint256 constant IC34x = 20534871837854314385218612865599447111614933027029207741212867283460435360032;
    uint256 constant IC34y = 7374915525179321170186253193153518197937230676073989159450912184783997703575;
    
    uint256 constant IC35x = 22087197757871411913364500064256360023797228245258146582804731355148921653;
    uint256 constant IC35y = 1690747599899033892164634479999064748874008856218971439514983095899656117848;
    
    uint256 constant IC36x = 19083914424852743009301799460534237305132781266532551490627209299886627635638;
    uint256 constant IC36y = 13898780717046843183073003695010437483034113782415892945708925616136576409116;
    
    uint256 constant IC37x = 6261199254357675464834466715889580463835407270653322052854684522360114963845;
    uint256 constant IC37y = 13498465822082235035654784814881572041225892700756388001345051915465959092367;
    
    uint256 constant IC38x = 13114467570210514347828866843835409179061658737618140045035535922105188297177;
    uint256 constant IC38y = 15711821701632781082408705911513895217955807785121599610712064678585510622840;
    
    uint256 constant IC39x = 12765221071082623312748649464096908425087772687317749701981333851199300696052;
    uint256 constant IC39y = 3085741910529799189161704689380723313090458505927127600773040769820828066530;
    
    uint256 constant IC40x = 14488651106961091252713191339821686331690265541174193406168014880039025243935;
    uint256 constant IC40y = 13373589255531052783447231567450160869910165989726956419997437051536739152759;
    
    uint256 constant IC41x = 17623532726389362638743747218943070917686469780066658888608169185048751986873;
    uint256 constant IC41y = 1734585663781958120577949681609293774301860323250734389594733794082124063505;
    
    uint256 constant IC42x = 18750136202647441882177882506194836757340549819684694728404507868802248827811;
    uint256 constant IC42y = 17051251596307648854886334588245132863180389442545962196428389737424847768240;
    
    uint256 constant IC43x = 17134125084376953526560762028711688554340478079630644774706921442931468292188;
    uint256 constant IC43y = 17487956849254220380690899952010618159329214005349534138847393001651490355094;
    
    uint256 constant IC44x = 19776954563416952565040265199583215126536787244291832752178492282008096456357;
    uint256 constant IC44y = 9663857239417764795877942262673110141621223310083687798387590082923999684748;
    
    uint256 constant IC45x = 5482620851600196061572722772001805503669278316682329381320988603063560904468;
    uint256 constant IC45y = 19083781146427254412715413977985107718663314826807313788826537441916769233950;
    
    uint256 constant IC46x = 15388514075712586988361437846508369259510761518249007904353908445825934439063;
    uint256 constant IC46y = 14020162231858578424303954541551144828122598322771731694285841517260100678801;
    
    uint256 constant IC47x = 7411582564938235693728793082095521683162492938583542778483698764411208428521;
    uint256 constant IC47y = 10985863614486140778247973734629579611596367463421990350027178860274038065810;
    
    uint256 constant IC48x = 3086711053627202075497155659948308958961593994589424734969003972992580928224;
    uint256 constant IC48y = 1308108368119271752047020758564886576479125695613240891994816873161154518982;
    
    uint256 constant IC49x = 13376630728764304793847303289345292097872439318377384681086148686048597499475;
    uint256 constant IC49y = 1065032471060074348823801207416904241590053563604059711028706068831925727748;
    
    uint256 constant IC50x = 2735452168659935946199744544246970654764178566813465771818997258221879500013;
    uint256 constant IC50y = 19271612559467821850243768802571301539757276856686145277613342675492085132895;
    
    uint256 constant IC51x = 3354457015282383528680353935209303953518352266581864108677102220325719845319;
    uint256 constant IC51y = 20814253832340437775657331612352211768448324386007096883152207107867507050440;
    
    uint256 constant IC52x = 20063557255279355975459602339566236988441486829551143065685158892194087689885;
    uint256 constant IC52y = 10809573717799729256403107492671248907855433442083174510083593107529867209057;
    
    uint256 constant IC53x = 12260609638168298575231775702375231703144690210585339570382899742208896490486;
    uint256 constant IC53y = 2071788231520481845955721553674035873820955393377418392356830870008893327655;
    
    uint256 constant IC54x = 17921410194830093577901411369814136384301701233888473814720579646104980023515;
    uint256 constant IC54y = 17204900238767558417250557338513251228466566378260228102186314496273472237824;
    
    uint256 constant IC55x = 4071242372731092581077592319103046145875386034760633267487515477665475023799;
    uint256 constant IC55y = 4176907233107974514771707368309109412521406988056008334508055651709912518501;
    
    uint256 constant IC56x = 5960733674644083032761231101830108412482294617239967163544927677462082400339;
    uint256 constant IC56y = 12272930515417026740138044206562579043542586380301331831929895670728239257785;
    
    uint256 constant IC57x = 17466341931284301039095423172060818653427088187827448630546255413551702906684;
    uint256 constant IC57y = 17263795429248257090391746682983113392613907639611686509156442782302769300098;
    
    uint256 constant IC58x = 5092370487933081531717185519149484554456955958668569667763286660905626521765;
    uint256 constant IC58y = 3371832118185923623335577951168768826867203542978491901702482622947593715567;
    
    uint256 constant IC59x = 13415987051218630217964153050480916340232292900161046028900284303735774340407;
    uint256 constant IC59y = 10305489545987842920567605933552607804913575592785081179991183825780051400092;
    
    uint256 constant IC60x = 17940307213339308497671319983238683964362322095896993454741083899462492255315;
    uint256 constant IC60y = 18271383264074052148496030032736674585762244059002596193724051182800244508642;
    
    uint256 constant IC61x = 16991053919262557091901098150018434740937834719308503141914330730786773170256;
    uint256 constant IC61y = 20606016313332434548940825751946934903425454661914289056789922846123664022019;
    
    uint256 constant IC62x = 2773384912448202467447623559098886014023491576018207407344823668038455109704;
    uint256 constant IC62y = 19356497177579844565676818772361630937943717301472463052536210987360776343744;
    
    uint256 constant IC63x = 10690082878429067707363340049393513126310015201943451552509583867384555834567;
    uint256 constant IC63y = 7852901504539684688588063862250228659853784519607357863771427939147375329530;
    
    uint256 constant IC64x = 18146210367726352408362522338418342636333980081829763437457944796504776239805;
    uint256 constant IC64y = 17249846635501505198967242599497838887363379297529327700118140591078987301721;
    
    uint256 constant IC65x = 17479503946561865301998563711134568857984399570404516751293923963077270622150;
    uint256 constant IC65y = 11690562669373466081048904560447993403270177845457694217478038019169513563417;
    
    uint256 constant IC66x = 20259465703600379813695651030943148388887273390460946588437588614346250705407;
    uint256 constant IC66y = 13855508531163836076698235874206199690679880678441010351981194795486805890659;
    
    uint256 constant IC67x = 9537855541508365904426098570555577176516265042362423331608997846681512352017;
    uint256 constant IC67y = 4050137933923913523930410459330824132023073958785039880722863132197795292806;
    
    uint256 constant IC68x = 18477266214747069066579605879985538554063689026773173407191269192457885598071;
    uint256 constant IC68y = 15692778841869769715394044391797741644313343573887154899375683675754308421990;
    
    uint256 constant IC69x = 267657976640608725503578835358616085361488890925140900780324117659425095169;
    uint256 constant IC69y = 21326183409624056892467386384637780641825763918578645116062949055343030691462;
    
    uint256 constant IC70x = 14444981191847388378719276983082156812268097022649537494885433675380261485569;
    uint256 constant IC70y = 1278303898554549990672947189791094410126969154493143627216482094085031677142;
    
    uint256 constant IC71x = 19701129734774512516306119384677585189583418191350415810496945339445602054368;
    uint256 constant IC71y = 18050182036419504373226356277351815931854597830380496080310922989852637365401;
    
    uint256 constant IC72x = 15861414578950452710119253691076839713380558292828496644823788990091917260312;
    uint256 constant IC72y = 20424962195025289878138326754141750012339648334054211016393546372285564527635;
    
    uint256 constant IC73x = 1852684271408208679708470635597536454026990507559184798381811913163594717388;
    uint256 constant IC73y = 4128120367283109943933810364400549436641631181209593133104804735319230680237;
    
    uint256 constant IC74x = 21248622990585165717462010311073484599579461981110177803480331793581996021461;
    uint256 constant IC74y = 19778789799733401347212636280359087298050141470087467879271492815486419623855;
    
    uint256 constant IC75x = 14422265861428199629482796533127532737821139205192117395380066453278625765446;
    uint256 constant IC75y = 12832929629708440451802068414098867830648916491757676850621113336459457188984;
    
 
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
            
            checkField(calldataload(add(_pubSignals, 2400)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
