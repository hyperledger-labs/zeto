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

    
    uint256 constant IC0x = 11404037212840673572632930437522560870347672653180467216434840130974273594440;
    uint256 constant IC0y = 21425505393856475656679434729695523050212321762381852232450937832739099860510;
    
    uint256 constant IC1x = 6872167114448394106270533407332444823901538995063137577592830912484247657332;
    uint256 constant IC1y = 11070324778849993590099249204126104988116864882698086338464502573184829984892;
    
    uint256 constant IC2x = 17005155766466463623256356306569178082422780050886219304110508539008577942790;
    uint256 constant IC2y = 6645711158164250777813648884679232817778347166491006644915006912885832085908;
    
    uint256 constant IC3x = 6105492203702090178920463081360026681515848045821184242803162236991904844952;
    uint256 constant IC3y = 10875008112235481751146942355732804316707960397182099004617679435154367424580;
    
    uint256 constant IC4x = 7622677977514691470420065470681903862807578006308420981935858183330643846468;
    uint256 constant IC4y = 6509183779548000411359914125284252895436916691342610781385889988600563503325;
    
    uint256 constant IC5x = 2965883664774596127723947998639213956501248980895979523408251544304009748498;
    uint256 constant IC5y = 13576495651838783746883944397252645983213501057443764492976287868539233594187;
    
    uint256 constant IC6x = 8418898673811280860060895485138090919625248396049745235381706436185802037561;
    uint256 constant IC6y = 14365868270018056568340658191358797319301236359264237453222330311419495315441;
    
    uint256 constant IC7x = 21872523688166357173059368823878930443051430610302001609791745682202354464162;
    uint256 constant IC7y = 423196183391911010491516767568876488854772137316480782248281416733831020987;
    
    uint256 constant IC8x = 18823132472283478293011551091221182010294320389917228172259396340929160314437;
    uint256 constant IC8y = 1123276431323771149709338248293410072632997811473178752826433179510070758270;
    
    uint256 constant IC9x = 8893889329261867284075369360882152456945924188177600871918655910910694563552;
    uint256 constant IC9y = 2756515906170597624948561385987451329613317837698514085154737428707455910947;
    
    uint256 constant IC10x = 13903182554588034197979485207172323194429239445620718373534238152412642752113;
    uint256 constant IC10y = 13968557790737055720692104014461641586377379465942374371056529895303288001253;
    
    uint256 constant IC11x = 17392879474244869033702164674733293539277074999988933455537310227756603818522;
    uint256 constant IC11y = 1837639243427679698140955302334330565241404751648490607987653067385594813315;
    
    uint256 constant IC12x = 11490220263830979691307628420542518863780405973604202090198880562581971730401;
    uint256 constant IC12y = 16344723073203609383592073697498203608475480526715882891286592366809948476258;
    
    uint256 constant IC13x = 16008746432052304393269365086188461223827207262397776629466085561025575654697;
    uint256 constant IC13y = 18494702468288174329164217302178940069987758783652817256563146392415208231389;
    
    uint256 constant IC14x = 9566299458216250011354022613148568721935578304695353760949964209859258908042;
    uint256 constant IC14y = 14313184345044167565767398313155014371486774977199925638831601648310681108099;
    
    uint256 constant IC15x = 10610611909983126456903043218873332316270055983110296109396474877260179989305;
    uint256 constant IC15y = 15521637520916042916502634026608501307036572492789795279012419921305975928433;
    
    uint256 constant IC16x = 10933325500679041508147765956505490264485799336191979082997562487689309831086;
    uint256 constant IC16y = 13547150032379224234348614311008941698837307854805158118173894933454450607105;
    
    uint256 constant IC17x = 11016489095148914600230591622274492718602469756517555874770995045010723581997;
    uint256 constant IC17y = 6286989684000598832913369801562564026139933468017011777975448019929846524307;
    
    uint256 constant IC18x = 2512282224041581416526354862014464985610444661773197950122073508848871059466;
    uint256 constant IC18y = 11830387902021336881291290132716184275879862646358374674506875444627725034515;
    
    uint256 constant IC19x = 15882169607487488546160877403075658457278196824461519436677670134182948863320;
    uint256 constant IC19y = 14800307073577852087163432743566720402261967372977558160783260612848985834346;
    
    uint256 constant IC20x = 15865412554928486021440190578974621352654856824818051387104622645251216448108;
    uint256 constant IC20y = 19611385333821038149534177252517160914502434819132930257542257581563949400793;
    
    uint256 constant IC21x = 20694065211257385796215485146252920365460719903096029011844855807948573021629;
    uint256 constant IC21y = 19112408177329496282403865646277684884071195740345712628263398229729553707370;
    
    uint256 constant IC22x = 2148401418709517236296420123313286578637181331673437910912830199358363855337;
    uint256 constant IC22y = 14598609833371925954632315945126218421340844933290825811752998292663243204435;
    
    uint256 constant IC23x = 19473329822268716867469980011253469018630646213037670693260830612548643585697;
    uint256 constant IC23y = 86901092357333657602733548738381034322326357470847426476439103749486341786;
    
    uint256 constant IC24x = 19644727504780680891909864080311565985294857800360523399911745419731110626667;
    uint256 constant IC24y = 14026034183114319223239045597017239698413618975588801467919798862033488502922;
    
    uint256 constant IC25x = 2064523285236578349260167212320832036297468564740058926515600300045778968191;
    uint256 constant IC25y = 13845649529687475695260469499830003729841883428420727322496554158894200244667;
    
    uint256 constant IC26x = 18598705373531190844092667560641184122534089957570701664978098025954723434617;
    uint256 constant IC26y = 14368369786261868229642901706423870846509054310952678629546418898144664102315;
    
    uint256 constant IC27x = 19288961582074406896859919471819735713295402019571069382688791488401504381349;
    uint256 constant IC27y = 14479210884023114800633538429290401119662007827392245735749293131534083700594;
    
    uint256 constant IC28x = 13704620994738345989524865653714889229675593941441383149258155755252092576430;
    uint256 constant IC28y = 11662640870904589421555443016852830969105565599105052286876049846942572953982;
    
    uint256 constant IC29x = 11243017996492457161447880780352850077191302748908817511476904026940491466352;
    uint256 constant IC29y = 11995857542543741159887076452869529779563427953449634977204947290313350475663;
    
    uint256 constant IC30x = 16113430881491207863289084463011225947976460194440895085111400796955895636627;
    uint256 constant IC30y = 17838330081070354742089190848470690580658246234173219840018628620126910183530;
    
    uint256 constant IC31x = 18319715062970499122425757907861518784485901476673487062496017860649941984882;
    uint256 constant IC31y = 9589070691218811815713654631435169561984879525214866545718791563129736266949;
    
    uint256 constant IC32x = 7439557303136603897825089969170185846824953096503178784095839166673197450809;
    uint256 constant IC32y = 19597711487980754996752446870642893719823636726109896631474284061202694494215;
    
    uint256 constant IC33x = 9500583839652871763679857107043836958964806158662900141587519155748828359429;
    uint256 constant IC33y = 8378533833481147637462506284847751130451977457756370971479285917681776233906;
    
    uint256 constant IC34x = 1548136011066679181476357079492427874144098255096863621336029460704036031315;
    uint256 constant IC34y = 21509080884662577921916156061057603662679954560577606325461432928225873875605;
    
    uint256 constant IC35x = 3074040049180298378810281335738164442302925975760006531524395846638745504487;
    uint256 constant IC35y = 10680181455351195374711648952199980778400290074176085716741800383736386186753;
    
    uint256 constant IC36x = 521334521636723969954885497679396109080240782319371686084533251863006823209;
    uint256 constant IC36y = 10110611167655465637240735974308771496888587346502280578368880834572380319399;
    
    uint256 constant IC37x = 4923805680619712558041148627180412894618814370791809218148710342274158135196;
    uint256 constant IC37y = 9212367429916653163823902174986132287965038820557736474759520196978807397837;
    
    uint256 constant IC38x = 12942468286429330025491680881104099355869907877123154621478281823281672438460;
    uint256 constant IC38y = 5742387420203373457523150545164604058553496542789525729170481508995453734501;
    
    uint256 constant IC39x = 13155721758501450456540788878581083375027348389869383871707038304112469426742;
    uint256 constant IC39y = 12554842297586489610503656125055456018515638106992178611896256706597617088089;
    
    uint256 constant IC40x = 1702130183066982166254666152038352805149098126180934830671268263292398688611;
    uint256 constant IC40y = 16604750710570503491425354769291827713972899006555075712140828454064480745026;
    
    uint256 constant IC41x = 1365228981768165624203176608340171044512181669211797179016988098447897917267;
    uint256 constant IC41y = 11778052944130623410459887035993660991610453258914930831716279482009590865197;
    
    uint256 constant IC42x = 14413764977985707179587923627137261115344163657318165490991312771932534750661;
    uint256 constant IC42y = 12338277752699459540355291103989771234223976025802893851898760966168655208509;
    
    uint256 constant IC43x = 9662696933280976819522967545833947214825903773663391705071728222768614446511;
    uint256 constant IC43y = 3886981075841040642068662376865402705881018963189896314499583323426736726312;
    
    uint256 constant IC44x = 7893827002631979289339382779588656048240926480819624493966014677932566556549;
    uint256 constant IC44y = 2910945823597223335760145409168891190251514029001272174979931043461133021252;
    
    uint256 constant IC45x = 12146687162064162015278671959587816491984447890268437651874680880115658252338;
    uint256 constant IC45y = 1382694196057536753094581486713070773722425441434728740859914238433065048750;
    
    uint256 constant IC46x = 16693082778701816387747479746397553215979942385824176829754676984562081772126;
    uint256 constant IC46y = 14496645008497096362528322581099207004874034879330545480500953741599791457890;
    
    uint256 constant IC47x = 8286409065768209871837336774944425028432389035202051815526184412475138582493;
    uint256 constant IC47y = 20958494067098301376903324838558680364883546494814833116272477564892609605161;
    
    uint256 constant IC48x = 15298152562368992337079858255415472968126110701058013835922171087942080302103;
    uint256 constant IC48y = 844254169216206849304369762676085270041914736725661888283292285374147213687;
    
    uint256 constant IC49x = 1698441718582791237234567660348671026077157747145627542608739184116395583171;
    uint256 constant IC49y = 5585005773720577308334698383470773912077271192301413188583487899651391115849;
    
    uint256 constant IC50x = 6653538654074091654188927988023164345291706894738351779956844172268866786754;
    uint256 constant IC50y = 6972350141974513410820980065716821457085663786160924509547609817577181208289;
    
    uint256 constant IC51x = 6497759326470292813088363448133951958012847198513433416477575045740163539870;
    uint256 constant IC51y = 1308594356454062378672832124907657717600277104883173152512720068417350623200;
    
    uint256 constant IC52x = 18746122564165976323032258039882424322333543525927629803618779819709085192981;
    uint256 constant IC52y = 12184371638620114464678937103718638498223637355477271685434342905827480281001;
    
    uint256 constant IC53x = 21439245090204325911043610869628978696448349723226529238033596971045441976590;
    uint256 constant IC53y = 4850002669560604629428286162665106392161886556122792034049159947730646935953;
    
    uint256 constant IC54x = 17466144696861958187963433421335745915385973819139252342639156590840230068779;
    uint256 constant IC54y = 7727396074348682523164053254914396056918609258424874802898232081919951265093;
    
    uint256 constant IC55x = 19581664116862314698531866032800093258332752318836923178004755497061497685939;
    uint256 constant IC55y = 11126414839850110510658748241547722042743808626516378590751397180032399448033;
    
    uint256 constant IC56x = 1555275445426508726249642760668249847953444834772971785639302561725466137631;
    uint256 constant IC56y = 5909014838425697251873633670948619313423830928753494466999644605997815791978;
    
    uint256 constant IC57x = 1946091155935944224284156702874151862203671995144719721047429285162747723900;
    uint256 constant IC57y = 3842830934553847421364173075076353381103652774073735727625744911976909788197;
    
    uint256 constant IC58x = 13984891138851211087299040065988766976902738506098457294667503692564004217961;
    uint256 constant IC58y = 6833360310986886937449222069493518133304219498132532145214559957040846778504;
    
    uint256 constant IC59x = 2521309953371589468717909695101426175839555288319725239216129331281448745343;
    uint256 constant IC59y = 197291583285144987866011132212228598644754939257042343352822289247618272022;
    
    uint256 constant IC60x = 3942043936398919064776361221366551469253623864623716630117320457793968943161;
    uint256 constant IC60y = 19985612029348496207223080749235940035091947628854435492590213727538807148494;
    
    uint256 constant IC61x = 7204107713915577578901374018972522972490292157060262783210244581961609540563;
    uint256 constant IC61y = 17073077707887736041347300307350478930095184022792756258220523873053398332033;
    
    uint256 constant IC62x = 18451637118255339550722635151945423381845453206881952374015537057482835516462;
    uint256 constant IC62y = 9507958093355892413764910279033827052743460181462735227403625313383913096747;
    
    uint256 constant IC63x = 18683843793609950074502136373814743023777839105535063161991103434032176456683;
    uint256 constant IC63y = 512327050737311005644957835956341501076636880254604877331797429219007040234;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
