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

    
    uint256 constant IC0x = 17504848062868348026374002498224723996748756089276549138002654517982016255538;
    uint256 constant IC0y = 16387507367412557460257377765383794801476813095817061623259001184927071106034;
    
    uint256 constant IC1x = 2856069502693004785127392038262393497974744695634372998401820715110377580575;
    uint256 constant IC1y = 15561059156075398193317869131598022491610304991667406081651699520146364765780;
    
    uint256 constant IC2x = 3859389872830912436200600964789102024361491814219596610803029929946644931037;
    uint256 constant IC2y = 1379316890215683508391001779822326692301880648522444673041390804439970054068;
    
    uint256 constant IC3x = 8415946265759935198667780399036578786314201446216726794902855492967332252013;
    uint256 constant IC3y = 15809101762048384534955622139547502714750399693643041128184833018326642991512;
    
    uint256 constant IC4x = 20535800429315416894612599549205808164074195628326052033986955795418689069905;
    uint256 constant IC4y = 11366931152943347478625131981318793312836195302128744391498974801567323524615;
    
    uint256 constant IC5x = 15829477644400158320246641877331704309264586925310327196539914283139342353644;
    uint256 constant IC5y = 9934659057803690299249584984817022967602349279267611443853677220761678388542;
    
    uint256 constant IC6x = 18918146804733231422333304863438872219739334678962399068661097122605973950262;
    uint256 constant IC6y = 2343376008553314523127702902049483169606988764179316258282911398991407702768;
    
    uint256 constant IC7x = 5231213558934753070201601921131975968358823135926337144767682276145542464989;
    uint256 constant IC7y = 4665602492217868979300129137374085100174413837649811540289188169123300996478;
    
    uint256 constant IC8x = 12336799161694575597638898320521434723260248461665346045536341492377334909750;
    uint256 constant IC8y = 4637784107473356705217888916047150724972967899841641299327891030782008485610;
    
    uint256 constant IC9x = 13827078590544495241328131801668858903611645676710343835547244977983692125329;
    uint256 constant IC9y = 21410062214257392592742258923502999657896516248971868238962723630823346174229;
    
    uint256 constant IC10x = 16648148804443180403693863299061946840717694348838543762562820313123418826667;
    uint256 constant IC10y = 8195801067000683311584686635958018789966651244321576016528996434560391429285;
    
    uint256 constant IC11x = 13818449178804543430163997020412248802763660211216674889312893590596745982432;
    uint256 constant IC11y = 17048611745560760119354806941150155291932280127893448128213081928960037394954;
    
    uint256 constant IC12x = 18033428927728964864971192997985346363885015121354210336522092315091747298594;
    uint256 constant IC12y = 13365128640778017290772474101327304322106191025175089654914826009997183501245;
    
    uint256 constant IC13x = 4017576198307072663210157991121703896022494186654317864998385350827601491277;
    uint256 constant IC13y = 6717755372091993174391999198308039571277228379267328284322681839457836069352;
    
    uint256 constant IC14x = 18951077169344637293936120179113270077592805538523267528595076165889093420379;
    uint256 constant IC14y = 16024951146607749589423441411795299622228655287243270569258657281947614692069;
    
    uint256 constant IC15x = 1360708969957543383913365577994960778540930930157623031832678872345741108091;
    uint256 constant IC15y = 19188784503212735203818937702066709460520133020564105345650189896442261576792;
    
    uint256 constant IC16x = 2310084532603556369969881218026228249965185308444498344685656131291285072090;
    uint256 constant IC16y = 2684005466847837835929849832608810195680937122019646046234472921562603046979;
    
    uint256 constant IC17x = 15033210889123591887211381884005556788119507851747650399577670617675067962985;
    uint256 constant IC17y = 21635465298217685594774739863370705370837990509418620255911645885375058632522;
    
    uint256 constant IC18x = 20964847427539155244303558143809704974415302350648268606966770643146458239040;
    uint256 constant IC18y = 4976852868551769830359648093452564906077147425657133752050439032094469178040;
    
    uint256 constant IC19x = 5954934735275902994859735641635771081547956714325915040567497876417048394143;
    uint256 constant IC19y = 12342305689282435518046032667069855834926960332665248810505225445852009809853;
    
    uint256 constant IC20x = 17941161690977931098269864811397641132700593252578476448070438328580593719549;
    uint256 constant IC20y = 10992171856448189204497970359711415772839335327634080553352925596600238931744;
    
    uint256 constant IC21x = 2425648535044684031614952373699012963219840911718726909909891256136645080412;
    uint256 constant IC21y = 21518967218854415204283336476228379728243999731939483558032968206724325807574;
    
    uint256 constant IC22x = 280260936926782546013980159100142770253473969473128400047541356265542999741;
    uint256 constant IC22y = 10134098037208287844145086332209993231553540105278897499267027143835982878853;
    
    uint256 constant IC23x = 20630322258542475647304370850837690639747200948464440858494114988984663473167;
    uint256 constant IC23y = 5471360679957290184735041392000798787632877792653590599469301208859338904086;
    
    uint256 constant IC24x = 5111371584357786162832771597844547131550671201855188104706039744961582660796;
    uint256 constant IC24y = 653040201219489798026416604261073895543507016306735716151353126125677369141;
    
    uint256 constant IC25x = 6978336124426926881856591004162044830754073908007920213323571023785613542961;
    uint256 constant IC25y = 20414386314498291861276120712979377062332720562156578484901224643232480540249;
    
    uint256 constant IC26x = 16345303897992857692859745636449950638729953287455034304026858435009952917186;
    uint256 constant IC26y = 5878643236005185094442864082149593891339348972501610978330490869945951001658;
    
    uint256 constant IC27x = 17523481398586847238194919850947265455706770941799970175927495066504128872273;
    uint256 constant IC27y = 7471700472916472025019136320781313792713403580172746538799171676063158368084;
    
    uint256 constant IC28x = 2094161036937708942704900106707404659693176539918526900245846886917959088539;
    uint256 constant IC28y = 7880341502494899999695463060452869823744265572482012990875757815234964862638;
    
    uint256 constant IC29x = 12227797433782018797845158251242806466077383214640501764299030787081960976752;
    uint256 constant IC29y = 14223507300666949267825712869946068457643885067211133573755649286573564767881;
    
    uint256 constant IC30x = 453540649793160026316799015062804977909721800597914418509950105119312342297;
    uint256 constant IC30y = 12324285493695239709623854660026174408162078281863628396002540780982541880744;
    
    uint256 constant IC31x = 5580542283201294383971258676804392634747059901485539537837867891173931906725;
    uint256 constant IC31y = 18893651463971054272255885924027852040285006550612275136101519628602670404805;
    
    uint256 constant IC32x = 16053348515324942000894930414520400209998037357589282973515627559839553719937;
    uint256 constant IC32y = 18721430601727038239377701583956253836579793295356933421370242456531250291255;
    
    uint256 constant IC33x = 4207348331894209505377454332648293135047961513011552219208614177339885764996;
    uint256 constant IC33y = 15578406702422632993441451980677291008648229741735120457430480166703313489087;
    
    uint256 constant IC34x = 5638734168306965054319883075296665200673266975989878680177302242980003365757;
    uint256 constant IC34y = 3054907442264710302362313978881788880782770809199005375546833629175395917303;
    
    uint256 constant IC35x = 5861570516229947654739252134966410588166542172364647012821598504829520960520;
    uint256 constant IC35y = 21826590176415498013503020647935392823956167012515420325697166485087109341456;
    
    uint256 constant IC36x = 1163146016516187472740589974531980564637857783215779188095003814133427992849;
    uint256 constant IC36y = 17100204026966532131401470450964759258544383909937911336093084512571070125508;
    
    uint256 constant IC37x = 13527708705374185300712814674442001942903598446797709282125997239238565392928;
    uint256 constant IC37y = 8474355221953601073926090123462985374466496924904865143135852117705069140058;
    
    uint256 constant IC38x = 3808640281749836669607683401869874661662588536151452683315635118821978939890;
    uint256 constant IC38y = 14861507266593989874827115625593671744007071304920501849993048803704385010084;
    
    uint256 constant IC39x = 10194236907116302439622331517082527947776970543332709847028804137863312401718;
    uint256 constant IC39y = 11329005164482137625321319303919030985281584614017669696906810224293393629880;
    
    uint256 constant IC40x = 2175048060656940005354125903390105829157228568052786493865600961302899409802;
    uint256 constant IC40y = 20845091066389805874005537483311906148961944629004027128749165572499641740969;
    
    uint256 constant IC41x = 6513207037911904919854905415439872520001395253442037570879540199844544797917;
    uint256 constant IC41y = 21768663552313415329491685534136927428823171722456684854961607216944874160246;
    
    uint256 constant IC42x = 11143666812126252087435576182566526363905627516668442800728196103096410140946;
    uint256 constant IC42y = 6535255151577129566349664645385780221288149031850600269892969667152281389934;
    
    uint256 constant IC43x = 12216019667254591633256543770210142244306955316534898670848792497815288748407;
    uint256 constant IC43y = 20932736431997402628568150442959172684450592121020005476297963810554983857496;
    
    uint256 constant IC44x = 5933919850098763144777134426689808617420104756103652617673006846516543746028;
    uint256 constant IC44y = 1846818467291984087215401520026387243511815581026231594023176708787928601743;
    
    uint256 constant IC45x = 3550325488317807172294579797915663005069767530335953601988476431803051781127;
    uint256 constant IC45y = 19986059169930216696958502893247191080629716230489353335542951478141806211020;
    
    uint256 constant IC46x = 11680897079617705713544415674593237825122414254090279751291301975595017258239;
    uint256 constant IC46y = 7192914150142927503252523063820936177103915826937857509316891503321565576065;
    
    uint256 constant IC47x = 2194944632260890612597133046164513345176661225427381736733616125225090009231;
    uint256 constant IC47y = 20125380079300917290749136763381143149180127581158653088913932492057416883412;
    
    uint256 constant IC48x = 14422798646426772067663722833900085260897269980290313415292189180250359352601;
    uint256 constant IC48y = 771703103591355791449427823813448842147352355458537942689020853074754641443;
    
    uint256 constant IC49x = 14615753219316385282263522991969142859295978879684495081642174089355734612047;
    uint256 constant IC49y = 10726284617382468267788691700905497860909038954300000561095095525698258734795;
    
    uint256 constant IC50x = 17101999512384579394851655687877848773235007944785753742455387481074274316188;
    uint256 constant IC50y = 423071507367238120356829746625486510755573336530662107346332180257030287264;
    
    uint256 constant IC51x = 9792926841156931454106301139947287811673122135247907827156714190812449701109;
    uint256 constant IC51y = 5970908732417123977436766989527347543081758023388968529325238154277565717740;
    
    uint256 constant IC52x = 12706145721666739923414163788987123312746958734319163889121620419699709488765;
    uint256 constant IC52y = 4306164917367554262618109318601467317114306696451610147982033625958115348490;
    
    uint256 constant IC53x = 13221349951903657044803747239233265785265507566859952375028444203437980813346;
    uint256 constant IC53y = 10565134479636684577025748158266609122295088659249500688010380999868051230260;
    
    uint256 constant IC54x = 15936621239909675935495995025933386182121678876586173688942468329781025961453;
    uint256 constant IC54y = 8675648856225262437745421036662111826559370347795735779137840613949393851040;
    
    uint256 constant IC55x = 11377869237069746467451540359369426085441126079383682910319711789669692949250;
    uint256 constant IC55y = 946844900758779719927195974669359561147197227462088657885137274383506599072;
    
    uint256 constant IC56x = 12391847394251081516284908202445344119027771364094180939362656437074203234144;
    uint256 constant IC56y = 17991701997444862400258460727205796587715059621570231928646294725920133917550;
    
    uint256 constant IC57x = 19273211338074274131409088982613123292043184587862073818414163136972356711192;
    uint256 constant IC57y = 10596141629335780563818878207994516764687494527269573265381148633833675620704;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[57] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
