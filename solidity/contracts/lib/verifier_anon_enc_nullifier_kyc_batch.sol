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

    
    uint256 constant IC0x = 12858642186216573514376237800965234603650348168089173346459768469400500053251;
    uint256 constant IC0y = 12565095604564374485221498316349530377709382949948054355717909187503668328055;
    
    uint256 constant IC1x = 13138077759640600902994382164090740677763266688367946800443925142634362541881;
    uint256 constant IC1y = 7723900083385686148919365704874326680250569739012955417787349354561021447872;
    
    uint256 constant IC2x = 14219188412519089397214334581640115554216938530741107945688240997660263170219;
    uint256 constant IC2y = 8125001429497239326152138654137918018111779471251025427553277398926329934842;
    
    uint256 constant IC3x = 1759344920564294627929169355477706885942426765431124731801753927931354406526;
    uint256 constant IC3y = 16704901573493296732998549934540890651410652165343574367926253888287104473131;
    
    uint256 constant IC4x = 18134796096326614857057328188329348746820239703330333808300374025361274720547;
    uint256 constant IC4y = 5212627741252822716339446204636891514022844101746285343036769573045284953110;
    
    uint256 constant IC5x = 17172679838518323409677749691588214365220267398536693614140734792906786694323;
    uint256 constant IC5y = 2991979426725964436056898136610419475023575862638049862936910254220821506203;
    
    uint256 constant IC6x = 21499164383697425217120152657113615092287034447947963704384713090289054641288;
    uint256 constant IC6y = 16171064071592752054093802756901859080986579596068272427835573477325391292842;
    
    uint256 constant IC7x = 15779166016763002120428757835985278393297293764828050459715565840244474786130;
    uint256 constant IC7y = 10427231172566214799309001614729561335097611216682552831326126618221728130847;
    
    uint256 constant IC8x = 5327289818666334492489293856849696192046246016406082960977355506140119513181;
    uint256 constant IC8y = 17616031884310713244347063286442601125717694844051977165917682362170860747545;
    
    uint256 constant IC9x = 18030450872706033037354006711072254713141270199112344880139805848327481797010;
    uint256 constant IC9y = 10513592887287392492506837777945959827767413659405259959854692393972495674961;
    
    uint256 constant IC10x = 4524864247654964567469535929163200264726482171439083702442378388147786638589;
    uint256 constant IC10y = 9685552092365208253342839015231175128860850045536226039667213333241819189247;
    
    uint256 constant IC11x = 329539512901187456266567759571219202495070912781353242872678516063984831188;
    uint256 constant IC11y = 7145692892980733218772365595170632546143336877018824267081325757282839562499;
    
    uint256 constant IC12x = 1856227097482306211980388391341480809415523646892907964147258781905320155651;
    uint256 constant IC12y = 16543095693952504805605399499868446737720271872920526258562049981705755276756;
    
    uint256 constant IC13x = 5392850330837980073356747596993790265968885059537375200702635552143983472635;
    uint256 constant IC13y = 7703986526264547936088911510529999152674965393528913111525128992581017880478;
    
    uint256 constant IC14x = 18438332276363778446890024904290375852060920841748335851790867936141859904279;
    uint256 constant IC14y = 19448860375190721620648828020939963086196708594297444412804184163640327160131;
    
    uint256 constant IC15x = 5687865003847548563399579267783553733441567866638970403121677997146439381888;
    uint256 constant IC15y = 2191988301463932219325908259347620918047096485308726944866158692676637795702;
    
    uint256 constant IC16x = 10279050062086339246661120879488336116758244501989502881689491605008915076835;
    uint256 constant IC16y = 16428995848587898142982442127509205116369865808291868979938415680875182775525;
    
    uint256 constant IC17x = 9816468710844480490642228295217484851991632916656479508160966623636114865744;
    uint256 constant IC17y = 2754507490610896776041833030065834464442111984869142813935489770199722445347;
    
    uint256 constant IC18x = 13063622716125375763271649847388054009900310451705116384857933479525056090637;
    uint256 constant IC18y = 7994920979609930966967930172016154794817903198704598865209423920930323096445;
    
    uint256 constant IC19x = 9446214791657203662970190954509087731906331456494855211267704960114693003191;
    uint256 constant IC19y = 21776845737822675365873239039130394552130059996615606643305678438492320080031;
    
    uint256 constant IC20x = 1885050368269925152057295882804719070229392645420846097024137982919224633770;
    uint256 constant IC20y = 13856939111858796218571089026023802718312924290260146728675938282943232546081;
    
    uint256 constant IC21x = 13502981376532058730213267607742351586905109909912659823464058089453980543127;
    uint256 constant IC21y = 20334183524413245818866575266108429506934265583362822816829917787569232526099;
    
    uint256 constant IC22x = 708724843887592966090042763437951121939890272319205833027672386211527623095;
    uint256 constant IC22y = 7454601060816578950716347512176870469572088600363242636696409496663583341632;
    
    uint256 constant IC23x = 14119879497714697061242498044936832063422208534040076861776139957786619511982;
    uint256 constant IC23y = 1453030324388625916010093192863624023054896168656174654597601720517171766301;
    
    uint256 constant IC24x = 12271062616699198132689170125722784479703062504537137171812117819772997338698;
    uint256 constant IC24y = 3676431107623582185000426100556860805839409841263721120706707136997823046739;
    
    uint256 constant IC25x = 1824913022854221323644984530099684888450767469532774180747075347781876694520;
    uint256 constant IC25y = 3899508529597325237733109662635109559896217913681858321495980233622100331615;
    
    uint256 constant IC26x = 12557067370518147862043507833326506959791078712169384504639292653505027180142;
    uint256 constant IC26y = 15149998150719593703609290872828214731355245266578234125726145711106382632380;
    
    uint256 constant IC27x = 5829840523465463958909607723359876700469942173115320771166484161713718282591;
    uint256 constant IC27y = 9611195661719380898097235760700826835276531672392802668236453508531091035194;
    
    uint256 constant IC28x = 16232085544582714949187842523710432985519070155756937396743759694308936578665;
    uint256 constant IC28y = 197210443422913844441852265914771117016218524508232721795828526403802660644;
    
    uint256 constant IC29x = 12769874874317449448398890418579508192059699675487726291360286072338472626483;
    uint256 constant IC29y = 20316010443614392364943349261952083622802522827489619529138770824319673757622;
    
    uint256 constant IC30x = 9734129384094680547995613138054610125828593376069179848768658036657148002141;
    uint256 constant IC30y = 2992669327566926603317036570110950470027617440161819191608754193931132208178;
    
    uint256 constant IC31x = 20849948417143878841027639919843921539323288164074406402431253440498072149345;
    uint256 constant IC31y = 12314252851577929580908110210080275098313126995996149851034950184196310491813;
    
    uint256 constant IC32x = 21479332708681963336728261276489890777177424325004148887142756299494097988161;
    uint256 constant IC32y = 8055938613310177737404613036054909547029202949550716156874045771973008845566;
    
    uint256 constant IC33x = 5008871293707209117112243616376510892191331661540497630870164870896747559846;
    uint256 constant IC33y = 17899199427875819064220560246334197679978944745279461171935668858646558782444;
    
    uint256 constant IC34x = 7717582089942619775594873675301625275812288799122254877746559706915772729624;
    uint256 constant IC34y = 3108311010362495238282921984339085194514915755458797651891031322998829044785;
    
    uint256 constant IC35x = 16411921225538804984679777592020084775760110721570684792890887036573818540903;
    uint256 constant IC35y = 15841892232688345757902083996930794954583824054843049696932195726645313999362;
    
    uint256 constant IC36x = 21736822414829759563741087499118594450691632648115529553228374222189609416769;
    uint256 constant IC36y = 18611237143945577532896931945863068676495688217648848855327003088857927939826;
    
    uint256 constant IC37x = 6766779860330869694801899046307415551211955556038382164581083432846348700226;
    uint256 constant IC37y = 4348809227536966993624804311309128083139628407034296854485102604735473773161;
    
    uint256 constant IC38x = 9350799026503994956556626995121169898340280644400547473739718669680854004946;
    uint256 constant IC38y = 18177948831013317937829243162228732916573419255767956909271821104092205107687;
    
    uint256 constant IC39x = 94472296351831194468356019302107406410788832646145067030343354857803799160;
    uint256 constant IC39y = 9558041477637858711229451831649420106979368005401432633757775171711586712581;
    
    uint256 constant IC40x = 11924222116111824991860260042959961353002146666090548490374221736283466888440;
    uint256 constant IC40y = 9376478922816835111239590927155662092900844330330399569891165247903096420628;
    
    uint256 constant IC41x = 1595173533002108298188171571771398368233508884044110950580415280925498343002;
    uint256 constant IC41y = 140362717412579991719892173085430060259414714186248236075316046087103551089;
    
    uint256 constant IC42x = 18319434801672111353339429736097984802197477546441364369182430504203884564626;
    uint256 constant IC42y = 19880794555729491026065075422460291327421057920878428636196616471669642160992;
    
    uint256 constant IC43x = 14298591664878293241402475452930424038231646087519650086862341368082546288484;
    uint256 constant IC43y = 5700983900392255682138073827509652276340230564615029828872002207336359375702;
    
    uint256 constant IC44x = 1458893789126043501953887683321386018864367931522452938826459835990109170040;
    uint256 constant IC44y = 2658215231895679362259862719429564236615857838303074175288121415751956320882;
    
    uint256 constant IC45x = 11064112203686674647106645830419420709196890279102372003493120060412036512401;
    uint256 constant IC45y = 8287956196445426823797809778105408799892912161035528841955009267040480061818;
    
    uint256 constant IC46x = 13851027107271193900975432967315478096932479736639646379084637309147878017109;
    uint256 constant IC46y = 4450349056058299830503310354148491948664285038809958448024012287062316615048;
    
    uint256 constant IC47x = 17507493848332403906086412257257255935251347291570004580421636920681223078428;
    uint256 constant IC47y = 7085725574070197988412368205391156183838163343189008548401245110570804062921;
    
    uint256 constant IC48x = 4609097752117007954520151781287262899170776828894452682254041943016124235553;
    uint256 constant IC48y = 19749426748323419687598448893916427065141910432304107857075100318582814466388;
    
    uint256 constant IC49x = 16574218961687390602789028999728280967624631738160017828495726918156613249078;
    uint256 constant IC49y = 6044192185623496095086288960921583224741872927261607856236635918539683284576;
    
    uint256 constant IC50x = 21604305051063308453335012931969530744510398238282014894442855105112804266210;
    uint256 constant IC50y = 10413838090733029275617714737576180975243530500563360135536488074688057838774;
    
    uint256 constant IC51x = 7764408639814512603838154764631526319886606433261656743608229778106556101640;
    uint256 constant IC51y = 21387734773157015498518846574380673546980789344619461967223915135750558115739;
    
    uint256 constant IC52x = 14909548937315936008524922491636665986360008581945780986903891216922070762656;
    uint256 constant IC52y = 1664351798941531671559651874897518165093469946096549276729304888190685291746;
    
    uint256 constant IC53x = 4614238873201220965153939599187254909004047923819015976069683732158919316244;
    uint256 constant IC53y = 4722795851830618845884382156583439743547834690307002874535492698787108955839;
    
    uint256 constant IC54x = 15197864413628866316379587721636158247259025163428559670694689852712910729761;
    uint256 constant IC54y = 1401273212688352517008858641807567448019599897394916436625228295012498484024;
    
    uint256 constant IC55x = 8569310930376893641517507676031502998684387820332066052650291694549510548199;
    uint256 constant IC55y = 643274406765234728379874575577550537111232663873082733909143890382504564493;
    
    uint256 constant IC56x = 12762518128760818150886739516396083567575986702019713785717151335312011514231;
    uint256 constant IC56y = 3769605679192029754831571940160391650308784250092442010088706955736610380724;
    
    uint256 constant IC57x = 3189174500871313680764664480905638040127163693997910432263595362142979665869;
    uint256 constant IC57y = 776020819762105554005053452060716907505468678154595068076689353121408123285;
    
    uint256 constant IC58x = 19376317377196079728076712169101441440349901835370580888232493469749197110916;
    uint256 constant IC58y = 3592475204230655808801662343843260514725307826524878734046379671956873553578;
    
    uint256 constant IC59x = 4799915220692644649753533504149517128475232824338431811727801945614187697956;
    uint256 constant IC59y = 13378978664759993687957402332023218378859458045597192682065038434589196039237;
    
    uint256 constant IC60x = 17356963671387791136626612918051654683944675743132522135107394094390272672126;
    uint256 constant IC60y = 2492534485701186859331467741058320879033522878496671047543252133967346736359;
    
    uint256 constant IC61x = 5814024747431153344801549601432563738422231162213566298427981349001387435581;
    uint256 constant IC61y = 16721488692612711789362904139915784496063938968627134749709137464726589565531;
    
    uint256 constant IC62x = 8608343078905260825116309150626950288107712845302122699016436828442827782713;
    uint256 constant IC62y = 1260158607781222985952927525309925422129427684188843158276441590897597362531;
    
    uint256 constant IC63x = 11258425473065207572623984609608914538428760698685193130185004597164614478569;
    uint256 constant IC63y = 4854489234758154798649678878068102447416704048454668211527548199335632683207;
    
    uint256 constant IC64x = 21766168373449823414270800279443623372571839384674812702142944802401022394378;
    uint256 constant IC64y = 7703902925470304776781728964330997228580896245066014584797849560782888798938;
    
    uint256 constant IC65x = 1384530296890089198307647168215761779850576912076881001598160291986026496770;
    uint256 constant IC65y = 12584308877935799775759132281264923264277890903295365956142610321614279794420;
    
    uint256 constant IC66x = 21115974864023553736522125665071481959149729855452581830519528236376260491674;
    uint256 constant IC66y = 8908365689168526027483920455915005259849013171794785798355208898553832867588;
    
    uint256 constant IC67x = 6198100476911319381136526896818417893455790633249121384808914345569924897459;
    uint256 constant IC67y = 2936657732897541191035075338737281896974406581198472408041617234550530719725;
    
    uint256 constant IC68x = 16673561668055089127104948413320632058054932616922886831152175571308171291722;
    uint256 constant IC68y = 13365102546687537600231738228662786320745890137087025482429703191969849289521;
    
    uint256 constant IC69x = 14464971584724132509485354385552099228212256440708197314324265844596824179740;
    uint256 constant IC69y = 14645921625165329023515781637143761220291337478325886213902767732119379247927;
    
    uint256 constant IC70x = 6599504216018296719823288921727082748548266803767080991220398531137873889253;
    uint256 constant IC70y = 4876952318688787222636553235642837524139996295486611213239536460225129297934;
    
    uint256 constant IC71x = 21463848722714033440486185038945125724006720461464758537645318008277972427853;
    uint256 constant IC71y = 5841284683571800089782342281984637694003126889191389397802402888447123609554;
    
    uint256 constant IC72x = 16213464432225523495426109553030690767731990088934751096008578161557940302646;
    uint256 constant IC72y = 14823957153754707586465065897744710705654010901245601112247720634512696158604;
    
    uint256 constant IC73x = 7859589839267797163200602956877913265055164095747536840537064565208778460349;
    uint256 constant IC73y = 11629571171547336333959971915130356660242772799944866424256117128366330688742;
    
    uint256 constant IC74x = 7328410307801366440258605993259568961918657007716618533680527436559166571941;
    uint256 constant IC74y = 4671655370973164091589829545231556438180959758785630670937772947200496168718;
    
    uint256 constant IC75x = 14074358839369919045859600954876359018351022200323100354114813511190365539831;
    uint256 constant IC75y = 14874402639148570564877335066665498698798443974543001126724821220742994149380;
    
 
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
