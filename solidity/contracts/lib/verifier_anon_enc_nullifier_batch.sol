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

    
    uint256 constant IC0x = 12126744414123145446927544518860644117520956174461536844904979731739153937319;
    uint256 constant IC0y = 9695184835202931902032395296633846848346566651202119425523352011687050447653;
    
    uint256 constant IC1x = 195592937835855475172740086869646488202858994940627750986459540968521127076;
    uint256 constant IC1y = 20133094631443294605453490663465191307905205631306063705224666266432847314101;
    
    uint256 constant IC2x = 609379390311908960003738861564802384037207126281378208589622790217906675428;
    uint256 constant IC2y = 14024044248311930231657958997658229326035537165238311551943681440974095988896;
    
    uint256 constant IC3x = 14475258944672930562917429258419275006330018007564140466732576979600095527986;
    uint256 constant IC3y = 8383831786003410168382306689982076122231122079851574658280916054063860804082;
    
    uint256 constant IC4x = 2753592531034501021865774444348121286705967891727631798687428893089756717516;
    uint256 constant IC4y = 10956196239229551190326394756148632499327174891582324228559177700070138627435;
    
    uint256 constant IC5x = 20694727281247008058140870402913983925603757764003248536372865152419453726184;
    uint256 constant IC5y = 632675084443897428190075680269855858382656311919806104466344079557191993970;
    
    uint256 constant IC6x = 15429847497402072415689042470309154270994030517871107730087057583238557913338;
    uint256 constant IC6y = 5432278756669468541861545244015645582266245449985525214546028390310773531354;
    
    uint256 constant IC7x = 12596502105325655558267857046382181213663420017501532384280652854282498583279;
    uint256 constant IC7y = 10333147987837832448849674060620143310129669614798565710383011814099409472027;
    
    uint256 constant IC8x = 19706927842290699304337091536861015009104078371247908023635836241791720370976;
    uint256 constant IC8y = 12152105452911677618830339171375361924352461862712516323327576003984499587771;
    
    uint256 constant IC9x = 16502342806517603727453825489628207300342455950110654028899078381918045746715;
    uint256 constant IC9y = 5759609699403129611200125092383023856891064107714256272998295476995274119975;
    
    uint256 constant IC10x = 15221251781596258119997351899631148736262625069933837816302411218064388784101;
    uint256 constant IC10y = 21714792109295217531628722325832557564632293527405759778556005756241745940902;
    
    uint256 constant IC11x = 13518783476272320621059295563539618751199322165040898390459311820772920006328;
    uint256 constant IC11y = 20348572405520834933650462837534509197678154321262996827351132403485707735007;
    
    uint256 constant IC12x = 3085516350134090993142344171310595321303355811767747642909734046142759413333;
    uint256 constant IC12y = 18292877018001033289323482707732762697493866308762540047493452370416598882671;
    
    uint256 constant IC13x = 20415604312840579619461394202638369951741974304444342076923070910792744270166;
    uint256 constant IC13y = 1274709640988443541674157446934369153698888932825153138931739737641414694825;
    
    uint256 constant IC14x = 5858495509291051391546986394308939271118066275102133287209201740349735192015;
    uint256 constant IC14y = 14561847678802194093246461244839677155048289046064941818821298670851532929175;
    
    uint256 constant IC15x = 9907641005437705469547042991575734390388809601076326909237625045131034319622;
    uint256 constant IC15y = 19228656501051437063502091175033925062642380193719554208510346953512647375465;
    
    uint256 constant IC16x = 15683266867669391751788871262440210660433189459096145429401999628086509910994;
    uint256 constant IC16y = 167032798777044716931677543915419096661362132560388266364782869921944477073;
    
    uint256 constant IC17x = 14379095517200257325173372890767390667862742491742696929601242603656637834384;
    uint256 constant IC17y = 19300151202444669113633208264532627998474371658767796608943018449744115979864;
    
    uint256 constant IC18x = 19979595040717998606962225834005938237531481513259865988215018262605224517880;
    uint256 constant IC18y = 21832910879168436184260345537048484374140139897617063690564706843941073502156;
    
    uint256 constant IC19x = 8226426957042014569991432650455316949765932564299138456555947664857114623439;
    uint256 constant IC19y = 6228408145117381653549320958239734390061251228728720735702635598241136382652;
    
    uint256 constant IC20x = 17772049787279101603624397097351662093398629430679036525849489583491916545941;
    uint256 constant IC20y = 6754896174898647897440194918577444380308237651917088540483028012130071465948;
    
    uint256 constant IC21x = 12428668390308036975156424643882363758080198297785963375946287369862732125338;
    uint256 constant IC21y = 7754229916510745472520198965378403757343034624927137610169519146053204953496;
    
    uint256 constant IC22x = 1151593409168857067491034330441560752818628055677134980028730195638046983154;
    uint256 constant IC22y = 12238796633655133229171421264868652590324604792233399738876498509127150935586;
    
    uint256 constant IC23x = 15130553149239877848171470204612941417069785217509981487672396229892643378048;
    uint256 constant IC23y = 16099406353286235569807649940674558048574755883258872577176185277811179253351;
    
    uint256 constant IC24x = 3794745696420163629058946455956008692538593039450146927979252667276878344635;
    uint256 constant IC24y = 13521345602435249413225916136398623110469993915904908805128428652627696269000;
    
    uint256 constant IC25x = 12972999372467026203108869807300469886972394303736354207616238357759320843869;
    uint256 constant IC25y = 110817155195077381550608470818272201981579466679958649026939036130976959129;
    
    uint256 constant IC26x = 11351987952539946970678101437449176359792007487358798597473939591460664122408;
    uint256 constant IC26y = 1308124816220407348542397349028779400655687187740795098032329552311132540023;
    
    uint256 constant IC27x = 6347411655408647494979217671534610942549776678980729506377609014193036126452;
    uint256 constant IC27y = 7650341917145132808217914696212924364920359501843941028327806385968924055369;
    
    uint256 constant IC28x = 2241979173525358989962235321215348074120583391280990146670854896634571001132;
    uint256 constant IC28y = 12185388424274874369299686917985366094479590786809423606708624138284993838412;
    
    uint256 constant IC29x = 9735885194340002038427422932616677437854464253276355235258485361692033205001;
    uint256 constant IC29y = 21257134599531732880615697459431269975454138566860287614597128553986677458275;
    
    uint256 constant IC30x = 6412512253306584960786699140269842400589756139861876211328703556265682364873;
    uint256 constant IC30y = 8581407114773955546646978840736423622848412760263687116910154515793679605244;
    
    uint256 constant IC31x = 12178025225657053132665080940983731293612665002217512418283569056581120597462;
    uint256 constant IC31y = 9607455014410621145198574027726039505738635719236281427844203271758404744637;
    
    uint256 constant IC32x = 18085529495250116381253041145751943562444111566259228718399282295363598571826;
    uint256 constant IC32y = 8782823250887339530756219046446889579146907517254987922714625664444135020715;
    
    uint256 constant IC33x = 1684455964508238999037002157840252070214964666015086949858287180375841490215;
    uint256 constant IC33y = 17317823021755689870171330660384352287541747050385661387955290054027403355027;
    
    uint256 constant IC34x = 18856569786292380354208383060243350821329696637837390533524190265472245806265;
    uint256 constant IC34y = 15170385454602492244681441975340956197395228417205548910355740362616203767205;
    
    uint256 constant IC35x = 6785131565994547463443700779542841839255892841358327938723286020427767742379;
    uint256 constant IC35y = 20646141934315263891703794412883175937007598956830529048607441435267188352006;
    
    uint256 constant IC36x = 6142112958288288713721741987103643316152324184749373138621669384860357362760;
    uint256 constant IC36y = 11477690672876208127297157941674443659023591957852535964173518338911594550233;
    
    uint256 constant IC37x = 11576205874089682561141608979153392853349589278479920557765688886550510217158;
    uint256 constant IC37y = 20636343449556485913175020331073900113337601414770678635262733230661106311850;
    
    uint256 constant IC38x = 21269453497471835097480790967495702218084039255130168071556327157478305808777;
    uint256 constant IC38y = 5558133198433894177562744499152791083414114634148997050934566673629137061765;
    
    uint256 constant IC39x = 21390235838909311153232942303825483037076887135821993796282105744561739700802;
    uint256 constant IC39y = 20595831866461058789401812156840704130288771913324404760914744933513888205949;
    
    uint256 constant IC40x = 15108968727023597717708181716312456040954708879008242072671403834209124126750;
    uint256 constant IC40y = 21642362401012076623505143315610051538418868156813229541212544750053727665811;
    
    uint256 constant IC41x = 4676921041249368691385772973394433123525348781391629077041073696446952307853;
    uint256 constant IC41y = 3455150633426287414331416575295821544544983286252435425896827676498333277639;
    
    uint256 constant IC42x = 11473615547431627715479084652307953876948759423304237083348566005440424613537;
    uint256 constant IC42y = 11880397112407624959975296336174025329790822775528008256584164936996730043462;
    
    uint256 constant IC43x = 144280706472074616974111776963484785112293106689209428729696289517621396884;
    uint256 constant IC43y = 5004797331399302171724998314688238671269525162831195827603563550926662143284;
    
    uint256 constant IC44x = 17937416577514179595555992349206950762346371377579337327375956989789185992781;
    uint256 constant IC44y = 4706562120275640760035956575698254411341146065775454615083503549390428106814;
    
    uint256 constant IC45x = 6028502846265846157872138351926649108917378358004468502772419077751630260813;
    uint256 constant IC45y = 1610605450716392777245163633677702348842710813982929295353634279862192986405;
    
    uint256 constant IC46x = 20141063340663189157054944434716958785175455085953456315504103557589402942560;
    uint256 constant IC46y = 9420394857968479591478925576412437572728677224019988076827804618584163934194;
    
    uint256 constant IC47x = 18127069780096155830535755947830466630223230157049798571956174928085658798273;
    uint256 constant IC47y = 6801063294000630374892835246016369983130409633044568041486837112693654055188;
    
    uint256 constant IC48x = 16182149093020958269594216045958105379538178453077387255279216324992015353251;
    uint256 constant IC48y = 18316160889706950958969261837790035928674150206769644239725665787161636476483;
    
    uint256 constant IC49x = 3949908026086772315804919653711079994687298466353733764853664258194473256369;
    uint256 constant IC49y = 3942564944144782203828107633618433107646509102323544673560261314511736786477;
    
    uint256 constant IC50x = 11227539341683934358245829885986203493424842258885732580499528444033926111411;
    uint256 constant IC50y = 2641993489708465125648367588994825770902172935404386157992408160259561200325;
    
    uint256 constant IC51x = 15530708669345166982359883868765494131144955712473005394067986833015574932209;
    uint256 constant IC51y = 16854387299972883130761390411793023064332059279533287092365273012880855620231;
    
    uint256 constant IC52x = 19879013054445385110179746397531206765963581460620226886063673937947628876243;
    uint256 constant IC52y = 15699452951014667449248905102891447844972474113563121447359114087748893469079;
    
    uint256 constant IC53x = 8194440531815176404130697978708824056023090090624701927747808763629794457402;
    uint256 constant IC53y = 17019120385819361075347135636850402270968347150863260476373100439757997339675;
    
    uint256 constant IC54x = 20512293947868579324477132529274423882298893397674273690289712752649033483380;
    uint256 constant IC54y = 3856141993745158011335649033542760011301158064001661677116221331112179681778;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[54] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
