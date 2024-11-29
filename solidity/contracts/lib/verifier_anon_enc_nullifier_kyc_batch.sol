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

    
    uint256 constant IC0x = 19897988225659105939639408709293840562897022785921238146066575545617348312548;
    uint256 constant IC0y = 15644088698146438245644546730726249447460541809094423000622894418334512562175;
    
    uint256 constant IC1x = 19147347189359129763962233101180906458439869943878009136949214946695936249511;
    uint256 constant IC1y = 16443091035764976902250748734471996367063308703550388048936151831508916790167;
    
    uint256 constant IC2x = 4953721133054374020691168168912856344128159216890887779127507640745852989067;
    uint256 constant IC2y = 11274237764204185798746850229590615897364057340682130907386954538737981790028;
    
    uint256 constant IC3x = 12014343148735150516037826153897244442964751967857451125647538213400289575908;
    uint256 constant IC3y = 2256292164141221873783002769914552682959403069391248287193189320231972071517;
    
    uint256 constant IC4x = 16474111233563377351871041720154184097630499258863248315326764649157486024007;
    uint256 constant IC4y = 3465627137266950374889235022170115771490529465832689707716067214948698410674;
    
    uint256 constant IC5x = 21239768529935134066346277853440527215270350044622347770638217479251212158464;
    uint256 constant IC5y = 7127821513699748457811543966328448758787726945642497766450864724327997311167;
    
    uint256 constant IC6x = 20471972717426227458045921399823861507441545072162372877052112450284926318790;
    uint256 constant IC6y = 15690641790115007853742129143398636761393238908077402496312595876959907032754;
    
    uint256 constant IC7x = 12249524535261188578794643602619855658098993422806566432127371018556423636474;
    uint256 constant IC7y = 9598527391418900222199326929183254437955434178811007044051681289104233693130;
    
    uint256 constant IC8x = 15510118051699880475157329616372101916039157017977355842946660472019827696389;
    uint256 constant IC8y = 6045131352513101292902956652174831155777162555286522283250353347448002272275;
    
    uint256 constant IC9x = 8237962499167191717299109920187094525728582720089853220028379002409156902616;
    uint256 constant IC9y = 3872291793198670228738802910150553797306138588608369982742211481904207335377;
    
    uint256 constant IC10x = 11021190808920206708521175885367808506403710026349261813343566459531685391016;
    uint256 constant IC10y = 1091042997961435981758159431116424631308189158647147706316040872328615669781;
    
    uint256 constant IC11x = 20266534472504758304827002029642639845414165264657296437397072278053653166518;
    uint256 constant IC11y = 11265986845770000498619078678284319535435431545663693535794289369507168603450;
    
    uint256 constant IC12x = 7829346354910933388493469819519610668134763494342423656712830862266420333795;
    uint256 constant IC12y = 3686355576932585256071775977861837116925961022990963328330233893737808072351;
    
    uint256 constant IC13x = 21208081894525298601787151495018808718752027297242956532575493388691397517933;
    uint256 constant IC13y = 16099466525244958964216384923037994585998474402985453699741494498122742858053;
    
    uint256 constant IC14x = 8155455923920254572310584655650607640944517100266368967254851328873094792706;
    uint256 constant IC14y = 16913747786754588566372805507346420539490777863198363908045087223827314334982;
    
    uint256 constant IC15x = 2048484096179779713761128855383973330941996365333726515116421061293627244827;
    uint256 constant IC15y = 18127350277121123854599162995327296676523226803582849476525059141391839319180;
    
    uint256 constant IC16x = 12413888029629544447074201425628640978515839548759729638611127445926900755664;
    uint256 constant IC16y = 15941827976704593133129237037487776507467735657550185698053146651641464831654;
    
    uint256 constant IC17x = 16735941652697217872028257305895498271806983436521043335037295369269827038273;
    uint256 constant IC17y = 15218161999330747552273516029374892143801427925467335709703802880679770576390;
    
    uint256 constant IC18x = 17264079083384941891049531609844894949554212952663751277900409141172441081955;
    uint256 constant IC18y = 17602122828133046682157103204510222410265905744605305151852279762333976332786;
    
    uint256 constant IC19x = 8020783635884299785017413065536444513306274686322784698230436944510923802427;
    uint256 constant IC19y = 10778881148042898782718784574682898294924170688076480123274527754390704926858;
    
    uint256 constant IC20x = 19001011513924778900341458674569684250154217732301036185350531297988366259110;
    uint256 constant IC20y = 9417382914885223328442786658559621422715681857099431887918590630945450992386;
    
    uint256 constant IC21x = 6737376250348345240897516838886785785398634166153032340232008808252573602088;
    uint256 constant IC21y = 11494137845405047046843931866657459358217976022357861720539789336859723078084;
    
    uint256 constant IC22x = 10418844037018507387903974696172156935242789010920930291305974939743035608094;
    uint256 constant IC22y = 9845375038080405764939095853534189920226779400958692792333867633389719570572;
    
    uint256 constant IC23x = 4524775720259369737405012321787052186306238891992093167562861963484344478427;
    uint256 constant IC23y = 9062667940492452432577575085809718481829458861282751358857396244888253008543;
    
    uint256 constant IC24x = 6330629647499414850067070607038861664843239718602832398209869754798741155104;
    uint256 constant IC24y = 4228509106904581581274500803106488281935316257092981114054140174563190449500;
    
    uint256 constant IC25x = 1221451322915780656298044974415511567700230837260033136719446068524174831580;
    uint256 constant IC25y = 18860671826203696986352708992907256428505803631110483180242385659399495942704;
    
    uint256 constant IC26x = 14363175465381210503076426626102164077729617303895377369907483648161303894716;
    uint256 constant IC26y = 1039765371798554589534200523668536895007965927976091186090146272629550698693;
    
    uint256 constant IC27x = 10844866802204039461129597196036007555116887079776349691601311291532507935841;
    uint256 constant IC27y = 15080882338740425184306169377610855196155755750902218937806065382577568430566;
    
    uint256 constant IC28x = 7282748483105142942952914809234113307290499708397911896381074483068120123945;
    uint256 constant IC28y = 9708793634285407627079828789679550447452184518918624435255107054670757126024;
    
    uint256 constant IC29x = 5138747558556186688156598867345806497092946881293320489890503986815102199096;
    uint256 constant IC29y = 18586259913426258188835364490284030396021729525721719406501410102262565348459;
    
    uint256 constant IC30x = 13912363492986715690172761005477226514653135170137575720619506454153853346359;
    uint256 constant IC30y = 6893782072051478665218510432315015654626283852568425834965115505110253115273;
    
    uint256 constant IC31x = 19518992070206705110735545840976158925825227451671153494070370708056809755261;
    uint256 constant IC31y = 13458217343753689429814916577886510621498889168246485682346852264809078723259;
    
    uint256 constant IC32x = 1097235715910227033327833429533074269192586012028475731477475399244736688088;
    uint256 constant IC32y = 6890774447349851824422506064846539799917454135804297142885207816025033161946;
    
    uint256 constant IC33x = 8545915603207328763153687368654098572100376577619186155105002847474459274902;
    uint256 constant IC33y = 2643960856702059282412430765156638700883595267613637635371675378334184541765;
    
    uint256 constant IC34x = 13627824545339932282915723530402785197444023331093555307162151773294070744334;
    uint256 constant IC34y = 16397729842871261850876321810765009366490138863416313051851538739447146040558;
    
    uint256 constant IC35x = 20188227469347626703344636858723277892814222529623724593145308524258817102866;
    uint256 constant IC35y = 18672311838692498224986336996945086288515951917827273191227730907199318066039;
    
    uint256 constant IC36x = 15256264953155444178864372052190388745740189403694348626225720289920875393136;
    uint256 constant IC36y = 18360682089753574262770990632934119740864080565996652241985872899808342139044;
    
    uint256 constant IC37x = 18717442962331535590202272318263441978929468031878724494781454269431836231883;
    uint256 constant IC37y = 17590574677083835340991998839326355797384991388873061634267346161853561631569;
    
    uint256 constant IC38x = 11076360783889920282429185815607604170568101123121939825235000044462490227641;
    uint256 constant IC38y = 7427574263995658656753018038567735283390342934474190351900793103215611438674;
    
    uint256 constant IC39x = 1462264002981677971180254485360242717039923726030357662056431471319157988900;
    uint256 constant IC39y = 18451577591932356051072162835084126573452649494712946599906969905532550849883;
    
    uint256 constant IC40x = 5103996117361874266153897429070227880163051857527936709738256107021123964059;
    uint256 constant IC40y = 10298514862841858940068158221342901186487319548982710489211925713002720191140;
    
    uint256 constant IC41x = 8948999702210973406372134881948635946510474332688678660220353143234539745734;
    uint256 constant IC41y = 6223048303950568899098759623457578405129707611359398015997066745469192121230;
    
    uint256 constant IC42x = 4352019585330006073756433207490276457934814091393650065720438491948372704736;
    uint256 constant IC42y = 5513757498515638407564816542300645533152354753795296370722374649796922252543;
    
    uint256 constant IC43x = 5927628426611209356918335152730784104079050011117402094227629910901744605159;
    uint256 constant IC43y = 9877838872307105150242736616617522872683504421897410091835785586340892260268;
    
    uint256 constant IC44x = 3272095207365383123292357038475956866604679793253253156399980506608481318158;
    uint256 constant IC44y = 21119390009834480671279683098444252421793983335924638316052302445053202617588;
    
    uint256 constant IC45x = 15524623528151826914308944209298957568469790654802464429900017368067089319780;
    uint256 constant IC45y = 20355958234522381722457811342514656902212369583565801255991875779389127941658;
    
    uint256 constant IC46x = 16224839611196658969453565246937619963233244566057079437050956308679924240843;
    uint256 constant IC46y = 20336799151677945642604298760932420571889835262144137656536490327089217497821;
    
    uint256 constant IC47x = 8339471978208863402294510410942283067819048214469170681751225578049840432131;
    uint256 constant IC47y = 8298459084372792228889476340239847681193386953909531421349942406258528700781;
    
    uint256 constant IC48x = 11875480550859637947808894207205592032838827941125960824047492699758525818699;
    uint256 constant IC48y = 11075839599880437870246858014584314250085665813141320824371578957564816480476;
    
    uint256 constant IC49x = 5254307817213998754412376371283037873529591710480089652646118799901396881105;
    uint256 constant IC49y = 11054853095893833102717362446813843698715121342753068286071409993301790530195;
    
    uint256 constant IC50x = 7395382170554153483710791490305137139384608057295719108356686158575730277462;
    uint256 constant IC50y = 17337809641742678764682073922152759261604875977777940587364487755359595726961;
    
    uint256 constant IC51x = 21083048980552562131530946400344274016610869292674992152206187152085623241522;
    uint256 constant IC51y = 7456676987555041530892145143352405950082418081830676589879769492118412225006;
    
    uint256 constant IC52x = 19914185818525433169385902831412598876038182172995611925444932046375946530606;
    uint256 constant IC52y = 11598831798965680494756101269383487805192310849754637193158176933347213915526;
    
    uint256 constant IC53x = 17504272635653669426858847063712002458606460138895613672521319014395137885467;
    uint256 constant IC53y = 15689184425355674119503689260359241813185163185081594484449338800443378498413;
    
    uint256 constant IC54x = 15465219659542665620426495405536681998103741648185129201159031227478103592117;
    uint256 constant IC54y = 2802734936500785321693792921524080065764436372610850966553544941213928598941;
    
    uint256 constant IC55x = 17733539939663415112065248339369528917069654619093990576348486293711347443020;
    uint256 constant IC55y = 14430836790052811686618405722845642451253928989904196526784598325502566484469;
    
    uint256 constant IC56x = 4928543994611704038147352277179385380733570098567446392419815266578085485578;
    uint256 constant IC56y = 17051054565088810468716279795583749256581527659492822901040183166052166186347;
    
    uint256 constant IC57x = 13742960627575011476904634820837997444091392837326487675541171657548898428959;
    uint256 constant IC57y = 4639072684957897893629228345629263973380441920319481580744027202705839378289;
    
    uint256 constant IC58x = 20975254323835866453739128848385099669732388979835569116482688808568875195796;
    uint256 constant IC58y = 16966088481952089212696771118988567510277745140136149057737936756559858996062;
    
    uint256 constant IC59x = 21229565258629207413814184606278167035626886108012638802522058026659873245989;
    uint256 constant IC59y = 7189313184050165778564553327905395679010104496209129265001051754804493708159;
    
    uint256 constant IC60x = 10142203682863987027788022977389754498367329786100798604784103655633165315422;
    uint256 constant IC60y = 16337804816444273832066796146653272491463896547513296930654559517740725531646;
    
    uint256 constant IC61x = 8324485743441439934885854058624501904339089987075050009038035849079648510666;
    uint256 constant IC61y = 1934312867741305372813606742316942858809850762872752489442105906287872615193;
    
    uint256 constant IC62x = 8755272281132200881206081379155898769453478996201798721015264710014237556074;
    uint256 constant IC62y = 7214546438548448102397333066720146141106097367523450945533711844508856251613;
    
    uint256 constant IC63x = 14151475773760190653696652057083705672606177381042751000273096796627254891704;
    uint256 constant IC63y = 12800420004463021246404540157960866332438498566711132636992732955279206340139;
    
    uint256 constant IC64x = 13695690449116736099166029360461213999742840847215613726326344740675192046747;
    uint256 constant IC64y = 2603139465866620659347442006519027944297611908969018068686986645685466397302;
    
    uint256 constant IC65x = 1177637445668075826821915128727635425470608517042545111313078486114789416401;
    uint256 constant IC65y = 9852733692252826772847989918737146031585846991790555047871140343994085292750;
    
    uint256 constant IC66x = 11867992990579525933482499635947781741744735660517966949566848663622475787622;
    uint256 constant IC66y = 2618035820332247973637563479434568869003814421527376408004985511407775959172;
    
    uint256 constant IC67x = 7210966159925993015452861400592769434522839324976716414804569216802320545229;
    uint256 constant IC67y = 16843922512754149933191011829072752242547047876211570899862901647591520334091;
    
    uint256 constant IC68x = 16699697603759144825698262269845341328440017375857568954454051158571197106152;
    uint256 constant IC68y = 12064743873149952980455162878616600088123898688566016537225992371096617158713;
    
    uint256 constant IC69x = 5111463607690538467917768219750831882850422836940489209353077581903070827858;
    uint256 constant IC69y = 11169438770025069794225783878649624146742146836483670378641246869693228652834;
    
    uint256 constant IC70x = 14806268424773595685690193026701319784989733270013454892827036142313076072621;
    uint256 constant IC70y = 16288760063300179289346232429477717521626849188696502988196642640063738639071;
    
    uint256 constant IC71x = 1430353237650057060504828399719802014440428557490166602692903873236707851600;
    uint256 constant IC71y = 20191862058900648669486143866907803336456965089367613743221213864688314781930;
    
    uint256 constant IC72x = 2366896769323523901241446332481655507747547029378146308054867419821972959585;
    uint256 constant IC72y = 4758677958858409109884573530674283165976111011330480827892482962568567636825;
    
    uint256 constant IC73x = 932522054294169898289727664089770628793397540510265387790277817991002346477;
    uint256 constant IC73y = 17727672143512464871673552059320176918960281639457417311783773552358661794730;
    
    uint256 constant IC74x = 7165819180679872653731391678714162932431740658100242434605276187598030445685;
    uint256 constant IC74y = 1964871898459773332945756204888101791749504479659651461411621369045541738272;
    
    uint256 constant IC75x = 14018470570501794001125692119306265467735897080300787653423950509508986239091;
    uint256 constant IC75y = 5184136469273701727518309213768780794514014759843289868867671810595880412822;
    
 
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
