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

    
    uint256 constant IC0x = 2395789772256090657907391149545309971174185471509563219296269166677996715924;
    uint256 constant IC0y = 7152602764202850168818214524944751391285085200558474414091714257983317450117;
    
    uint256 constant IC1x = 14644842770843205417066836091765712107567556113384495891763878768715386428602;
    uint256 constant IC1y = 13427718602617526158589713189211663262615428670765653743175228169292946514930;
    
    uint256 constant IC2x = 4034569649798147153338102555851612620678233038435282496792170386073220774409;
    uint256 constant IC2y = 361238751928635208883843293710634898099962247596913051399516274584644337793;
    
    uint256 constant IC3x = 19102675628780940132341735686107681308136752517966774084791125049280131067405;
    uint256 constant IC3y = 19414975025228699999621841003355323411172068902711299314550577760107054966761;
    
    uint256 constant IC4x = 17530851367509537478332569983330114465026539337625887364350249230990522292972;
    uint256 constant IC4y = 17285222465906759569307996094158504963559191283686875780395130661898638725485;
    
    uint256 constant IC5x = 12770332117609025443002803390438958377412279742334848801167522207661574007620;
    uint256 constant IC5y = 19854275736738566265287208676451962732314294079621745840330697229815424924773;
    
    uint256 constant IC6x = 16921650104382042909263743819322938315215438638657307381387042250105699611444;
    uint256 constant IC6y = 21223800609553876367742089394256533004036002276780720923741068717574654288731;
    
    uint256 constant IC7x = 12137060077519535484639404542858284938716134628719354463883562251672841016703;
    uint256 constant IC7y = 7695903269947898406353525024834264542054966003185539528615699228567810130387;
    
    uint256 constant IC8x = 8374023289143341874461646570467112410933613032048074025993079701014309959181;
    uint256 constant IC8y = 16432874524902526015154460240212460926893088090831194914276768350674224977053;
    
    uint256 constant IC9x = 11888431444090639192902253429327281300663215057235364422049130215972239996028;
    uint256 constant IC9y = 12206407746110032542681441169893590806396811743899692107495504734439095128320;
    
    uint256 constant IC10x = 14210197014539804974249464761800705134668839033620980256084847029957751701740;
    uint256 constant IC10y = 6338278894791835946096350512957736583880340903163559263130732236739407982736;
    
    uint256 constant IC11x = 204458773094422483005350355332095742846516832215963582901632563755324078083;
    uint256 constant IC11y = 895479793138269555122675923719425497841032028176849527149434900717385347715;
    
    uint256 constant IC12x = 2116809647035495333521015880411766865806085873322260107525100683977251497980;
    uint256 constant IC12y = 13711911726367235332038833898620541524042935144343618183280300838572099630017;
    
    uint256 constant IC13x = 21684464732301340329292426285367889765010955147792125234703153331402267797958;
    uint256 constant IC13y = 10078705319204927258851392037674505822193216065323471908625989920060023524190;
    
    uint256 constant IC14x = 17331722291262750341370093458124376291767817443103553473514409279184627847712;
    uint256 constant IC14y = 4325709235783253636758908373652252243214004567791501481330959938149241829334;
    
    uint256 constant IC15x = 891591245305463886536118766415139950457332615880318775268296896058189785820;
    uint256 constant IC15y = 2471443246876434365130065518857418732863927364560322457724178206320242931846;
    
    uint256 constant IC16x = 13476003053804049003703771450029193865681894448710951565284929739314786291331;
    uint256 constant IC16y = 13070876159664700874578333859549466258876751862328455116460845494550851179464;
    
    uint256 constant IC17x = 11769314701297175952614898903739742012462897803051077117856517952909264657069;
    uint256 constant IC17y = 4740036360042046088214711398753546369812809932345426613135841633664050902282;
    
    uint256 constant IC18x = 488450941796600323989944152467846464381697497686071220677350750063868501306;
    uint256 constant IC18y = 6949322508683845898732619339614913575502354858457578943259372536003816771549;
    
    uint256 constant IC19x = 8380466311061588199463937807545277636898368345063774313454150683835358636393;
    uint256 constant IC19y = 7193147559922649220870304412312887279870767427818242870910226800578444436192;
    
    uint256 constant IC20x = 8343080889116005597691085802402747097420894160121720695080318038527047643215;
    uint256 constant IC20y = 3820398827303045682067588135761873658903715494931520781882152854847298042363;
    
    uint256 constant IC21x = 17581019348186462554351398251243007264930431831083937472161920659806646944455;
    uint256 constant IC21y = 5545625519661963107321592838017377921093662318854969693201536705933488779001;
    
    uint256 constant IC22x = 15019899365033272227834770080129431828983177784035033674853481207996731215609;
    uint256 constant IC22y = 14862791070894344203411269033129759399792308441548497018124550595215465031327;
    
    uint256 constant IC23x = 7833069343980574830924119347550350317981004961989247444133666893995974642534;
    uint256 constant IC23y = 18068618285555496116726700081909637563991012236615681179755092692561487278370;
    
    uint256 constant IC24x = 15721529392349171300295205905195145689301903533258809789880017130653980778536;
    uint256 constant IC24y = 4437416305470105672659207587457545045516892158521361436566757167018824857972;
    
    uint256 constant IC25x = 8851216879224204831036797102432707455186511677841863293631095726101915525017;
    uint256 constant IC25y = 15165856852615791024419519831848386483349133746800152800848332289335734272327;
    
    uint256 constant IC26x = 11005670225580141923784447745878255813748411464081858472384659933829659850682;
    uint256 constant IC26y = 20695347984793328597728111582416531042237257001154049278698607423877869874821;
    
    uint256 constant IC27x = 10266058958624888749236116936391595125406640557696898808866882703611755118776;
    uint256 constant IC27y = 9265970301529750993784797907906963350499699066254922807100740790905269160836;
    
    uint256 constant IC28x = 7642083775914108004174503942685690738227252348545876120356290913269302318296;
    uint256 constant IC28y = 21728967760491048148600757000448418144335251175190165492228834000031013218196;
    
    uint256 constant IC29x = 1545547328150775571154047252220004472922285345900191445922480440069729256259;
    uint256 constant IC29y = 14452902504972676857332304681310109659515973003806298868175884023112692501473;
    
    uint256 constant IC30x = 5526063274914106033464379027022358559686399566404269825832934166215843789983;
    uint256 constant IC30y = 5028866871729015251645467658929187934826817399700638699745133974438965190155;
    
    uint256 constant IC31x = 20755802968446898354292439049672911399394574633366385733074081350468832449570;
    uint256 constant IC31y = 4377769126252647165141250108385751880934330982108046537917945010166019375109;
    
    uint256 constant IC32x = 8485654510952531288976143124648864826827781164879444982639679678435645501029;
    uint256 constant IC32y = 18248014982863648156665682707637769130046840865654320448240193872679543741676;
    
    uint256 constant IC33x = 796918119016654045396642672203386191882529210505799603863498626902302063170;
    uint256 constant IC33y = 5389026112429222284781315586861744032602430945124948070174135083875692405814;
    
    uint256 constant IC34x = 21482580417734448005382474746931868294656288560711734023431849161247643547925;
    uint256 constant IC34y = 8758079914349411704650677209340365967072071650514121311302402325735688104555;
    
    uint256 constant IC35x = 21196887520023768249114289443854000666090119790025533097056868641356615579512;
    uint256 constant IC35y = 11163820770906223781819657406911304526171086255315937449442735821397440256428;
    
    uint256 constant IC36x = 7604417522388202942328614513362610680890878506197180316578751536559717962525;
    uint256 constant IC36y = 2939843898816592041995827608122852167668543647244033836125362327274633363553;
    
    uint256 constant IC37x = 21055542493039952584382904138567597632399079775901703484135178602266077668831;
    uint256 constant IC37y = 3202701234723099433340395968552112979260621577303743256235346705427765514192;
    
    uint256 constant IC38x = 18660117776394877335587004459543076421551688381560004333509939597346327922473;
    uint256 constant IC38y = 21497224631751955168876719082526598669282935474466412149277518195501899817720;
    
    uint256 constant IC39x = 21253590697279988266213584934257597663526201559071004305592244451012447081791;
    uint256 constant IC39y = 4147580699198201544046811264518235518456472705729353553660102909635079163048;
    
    uint256 constant IC40x = 3074166377876271187423114405408798450501344071433870195492493258624272162200;
    uint256 constant IC40y = 7708809998636628500158666176103636877564604901211771977005771176809293884444;
    
    uint256 constant IC41x = 17936739380422165530961066141621835634410103372703470365102124891394311698654;
    uint256 constant IC41y = 3319043893335468800178078503755537325156401517776004960436319252692297807576;
    
    uint256 constant IC42x = 6181292601046035234128829990835776289578607881715069428734078952804873705568;
    uint256 constant IC42y = 20659229908683127726821860148248821108763455979773745563975966412735326561247;
    
    uint256 constant IC43x = 9370458627943097125026324792741823486870296591318642765771505513857898112171;
    uint256 constant IC43y = 744635093409710657521097100836298421296034590699351719962500268199891176836;
    
    uint256 constant IC44x = 9919190179032467005401788116773752131950274523318593246173607906300611008457;
    uint256 constant IC44y = 15156676743850219721476572168211308795783266878815813000807439905405103832355;
    
    uint256 constant IC45x = 6658160304528694888503292297353118357706342172059186950970098461941189536087;
    uint256 constant IC45y = 10495615391756334357942944570814444439117678711860539910546077703424603304849;
    
    uint256 constant IC46x = 9770703959972291321398343823093722784520155293056219563602442354380782964369;
    uint256 constant IC46y = 13909261904971799053865612085602274072195843811412808770958493083156239535663;
    
    uint256 constant IC47x = 14699099805952360199087101845144502503621257684472570515927877045605549374408;
    uint256 constant IC47y = 11771937109801579058600259971552703976697766891744899275145646087469261151682;
    
    uint256 constant IC48x = 17885869510164349292789332278096118972277142539705492293712451564898548006526;
    uint256 constant IC48y = 4545109169361266639178498277660386987452407990741846439849677990298579981852;
    
    uint256 constant IC49x = 7738226593715142475289014106323387430850783539465754028506077413114828884209;
    uint256 constant IC49y = 3825558155040075761630307708447567757252618904885522948167015952165889092350;
    
    uint256 constant IC50x = 13022765160256860234730324498195034529870463612833439828713964216217615567737;
    uint256 constant IC50y = 21116042947269976657592219719799882768034741018701711429295371558665882314822;
    
    uint256 constant IC51x = 6709542905303492731551447866708991803898523842121926420302702170545532726953;
    uint256 constant IC51y = 973019171855364947510468016123723353763361234912947600498689035591648700859;
    
    uint256 constant IC52x = 4377659788840224343890186451065491757777232634956023112917775455976473478138;
    uint256 constant IC52y = 1850899692852449692694595008456720153875034872266109331332485494714931471058;
    
    uint256 constant IC53x = 3386771159756327107361788524766390354935217077370722959300022968317931650928;
    uint256 constant IC53y = 7857332045597874237594152504713409242974006906728422493123248909774872750181;
    
    uint256 constant IC54x = 1421692834969445473753600660994805729052845053692287147229413830384117507877;
    uint256 constant IC54y = 18609313630551838360429452801373096357140216801792233767522242184676315503958;
    
    uint256 constant IC55x = 13978573477928318008218601113539169458391367595940394780328898245931308566971;
    uint256 constant IC55y = 15875161499029862117615781021297140507917790795417892939868599447991394784462;
    
    uint256 constant IC56x = 17599803924953890024780208560357925837277038649663519647549298235135718540027;
    uint256 constant IC56y = 12214206663376524107629736616361565025064669974758837941266420409614527033441;
    
    uint256 constant IC57x = 17335726625208276424969431389237426248268647935492830693907943285327461733918;
    uint256 constant IC57y = 3289878175281260049234001586256787814187887370376097434074383613004649481358;
    
    uint256 constant IC58x = 10540244336986930192899557105894891658247221559462081332755731754117506103898;
    uint256 constant IC58y = 14349280740929458865970664317299373594836417476083773003659119296944534434414;
    
    uint256 constant IC59x = 3445354558748168865737498422630514209986714681677170733184635538373483666756;
    uint256 constant IC59y = 12236672722198520778481334834895484425522585670433327627873492479254216792859;
    
    uint256 constant IC60x = 16018624257987407702086532238735048436633839730871052173463058374032999558117;
    uint256 constant IC60y = 13620242697197653845082493276750366805639621735501294846896586720245004775888;
    
    uint256 constant IC61x = 4852688875304245231720799790138018344465306135302910776947773699386831614387;
    uint256 constant IC61y = 2665155515549220127801715671149529860626595722913279875568918269321054177273;
    
    uint256 constant IC62x = 206644070190266753013196119358273596948154028915751149974209713957558225094;
    uint256 constant IC62y = 2893566180904365708982743210274393008142248092826700707846128528256538939869;
    
    uint256 constant IC63x = 10886338539370850170526368547242768712403585065888027960150804191670033805154;
    uint256 constant IC63y = 10677170532005789716661199528195847256097694201435675675982800433143366594028;
    
    uint256 constant IC64x = 1304297074227587920378662771882715758801781845320477282145959855864352856313;
    uint256 constant IC64y = 9739596217817435275328588264967665346531627320241393866282732295943251818912;
    
    uint256 constant IC65x = 1493581648600383761799721417716407875028128277651222605703578337174610979360;
    uint256 constant IC65y = 12829164639684874035650840249197742088578894077041274951334499905903416727897;
    
    uint256 constant IC66x = 21077408101824313949986775924314329158407217026043768898835178550980002422976;
    uint256 constant IC66y = 15546960087947009739450691151451450357493657042220073591625229700192105430926;
    
    uint256 constant IC67x = 7756027090525376034848477575510699729701674747666543458371610048776574914011;
    uint256 constant IC67y = 17940094617753537926088236253313418017007593869389632623037034547251466927654;
    
    uint256 constant IC68x = 18249467853492577365842783360977361433848219827811766144944747622821816757233;
    uint256 constant IC68y = 7857082655366628139466857452570269180936701817801610874945311198066397638365;
    
    uint256 constant IC69x = 13177108541067063323060694526744209715025839110611817924869426803408303114758;
    uint256 constant IC69y = 17817562911343842555608279876809749835556645524303248171633666085395771262927;
    
    uint256 constant IC70x = 13922826435799581074757131384183726433166072680430227074724260664464211791615;
    uint256 constant IC70y = 19149409656120564224795979032648360435810540016648117136544487852908831474716;
    
    uint256 constant IC71x = 8214360934575471607036236356676787586901820581585165866372933882928238231545;
    uint256 constant IC71y = 5150470020982399844747702894253026635812097923466316667434263318099668875546;
    
    uint256 constant IC72x = 11504179774490617379033779868384064630126563812312681200271128129158099947517;
    uint256 constant IC72y = 5669465371214466635875682935767793484579277330398933271744848262122084540005;
    
    uint256 constant IC73x = 13880861402339442675577968947927031831320238715278284832329998671570607912622;
    uint256 constant IC73y = 18736712148533694097379381827650234735370140576347674641772699625675977378641;
    
    uint256 constant IC74x = 9976499769692929678766991549331377320772482117381259526428598326702854950139;
    uint256 constant IC74y = 3254382634403964695942665303485127954029952034645732860686806054512818920671;
    
 
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
            
            checkField(calldataload(add(_pubSignals, 2368)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
