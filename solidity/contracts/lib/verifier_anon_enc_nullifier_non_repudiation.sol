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

contract Groth16Verifier_AnonEncNullifierNonRepudiation {
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

    
    uint256 constant IC0x = 11263888196298953001191938443814296059746753093884576949719457783112627152410;
    uint256 constant IC0y = 13278820627633995943310174140903671810959740197422779805594980235302425745604;
    
    uint256 constant IC1x = 5211042244685257518812830048570250608140559777932171501360155047026426763150;
    uint256 constant IC1y = 17971687091520239629966740769789844601045096179849728137420386395797639764454;
    
    uint256 constant IC2x = 10462419820040311150951732771471668512870121781768793809270878604362013881399;
    uint256 constant IC2y = 20549272914063171912401373392896346258161970018208100109516639080254874585453;
    
    uint256 constant IC3x = 5841742349714527259245828894358710494855544628700974657688594033021774540228;
    uint256 constant IC3y = 6441581403795492150395874326814411581235847030372027989941155570687174339564;
    
    uint256 constant IC4x = 18496303702393801030722454696457427639449363010264073216952918158424570608835;
    uint256 constant IC4y = 12069337960623762811034403080143210508974746733341434393028093609981393009420;
    
    uint256 constant IC5x = 11750969644522980776414296014456392203727202445113265173285015464698499336842;
    uint256 constant IC5y = 11180060673818888564315982095364256527821226252019780345068347814636777468160;
    
    uint256 constant IC6x = 6231985268974236216216296540923889864403726558914240342973902801793013309503;
    uint256 constant IC6y = 18873153777488865213754222993559351660919311148474429328428690375954715507096;
    
    uint256 constant IC7x = 4761451869648636220918296566024471506851548298314229172496317816467070672212;
    uint256 constant IC7y = 15603377266261425283104616470408535626420679089607896850803713326508158054190;
    
    uint256 constant IC8x = 12099328579581963214990361140114341307485363400989267077399161892864179754921;
    uint256 constant IC8y = 8012561226384638858487519711997272290273534887056684225603398009091810167490;
    
    uint256 constant IC9x = 230452375625053365941131876649076751304064866692012851146167498012633343232;
    uint256 constant IC9y = 19724267244381482952372351763158860863609221332480966803448678214443388575799;
    
    uint256 constant IC10x = 5499702353091585507007997817078700241646822387790018492707078947324648104203;
    uint256 constant IC10y = 6983033040093100241972563820432930713529739252934793211363917170019487113840;
    
    uint256 constant IC11x = 21315763532997619662255447025486904652194476327848826136425219212518929417759;
    uint256 constant IC11y = 5750894037755684161640063158693923309930272924602041987444362724471374105825;
    
    uint256 constant IC12x = 4256642811355025077525708257430591309319045719449956700882911399651435269910;
    uint256 constant IC12y = 19420664561222915288565214195621305836646005999579444116987825929295283607550;
    
    uint256 constant IC13x = 21433578701292750401651120792999782910753919524705134407593361270156695487923;
    uint256 constant IC13y = 11603494315169766066642621345412118538992552404495438222744029937356300914972;
    
    uint256 constant IC14x = 20031783716778632555113481002912205783328662906838428828344625173975661571020;
    uint256 constant IC14y = 15499986965031649885148239022364466166148665045240417235186576854625828599747;
    
    uint256 constant IC15x = 8992013395418097308006543282826639532273314746372735948960206287054682158360;
    uint256 constant IC15y = 1615422210483554518518254384027376194664748788274748577924307338059551406598;
    
    uint256 constant IC16x = 4629280546147343772394290137981006260514853295240716294007743856958886987585;
    uint256 constant IC16y = 1584702331099718089032542045924113247265887051843547512294330869849536557196;
    
    uint256 constant IC17x = 1389701127175380877357507197865319123278566301837068942479482831407162573085;
    uint256 constant IC17y = 3477558702805358585320587844481304222513401766596803010546886511256797282393;
    
    uint256 constant IC18x = 15778586275741034280677486715674914249222515362089943735143603355576359603840;
    uint256 constant IC18y = 5472292772511510671195845877224285932512676425019956326483595781755215482654;
    
    uint256 constant IC19x = 16561716894977316576266451868198305486914734558440446379270983417409468725825;
    uint256 constant IC19y = 19215428116592915602200080610583600214110550521814344958586250014767901224394;
    
    uint256 constant IC20x = 6435961538575085590805931092359233869179492644526643589149772155241045519683;
    uint256 constant IC20y = 4647043630119673286933582581738947939134704511975734334399480520893860956041;
    
    uint256 constant IC21x = 12220576805388196897233434919060857079923138269552487253375421610134506445057;
    uint256 constant IC21y = 17480620418622223896539578913348018035020180342466198197986961578313711037795;
    
    uint256 constant IC22x = 21751653189349209381020073674410047004069384562060918880677239383144420611504;
    uint256 constant IC22y = 10653048036246857337333299198464378585216399552265904812245566248660722796879;
    
    uint256 constant IC23x = 4096142125818503191592810058875256208304674196711378965388058330916812082152;
    uint256 constant IC23y = 14746599581319772190649619245118163707154719471377166346478023726055690538230;
    
    uint256 constant IC24x = 5817628836817558772811252821464822616870368572396136215093864574514958310676;
    uint256 constant IC24y = 9937291952486682810096945589559658696444370577704014449443301914898953649989;
    
    uint256 constant IC25x = 5055408949144482407030431788124193916970715070926333386928549775964777564017;
    uint256 constant IC25y = 1653143226927246460788627927738841710177060778627757384336576468951512255481;
    
    uint256 constant IC26x = 15904523125669445373993550771208741085879417687566176640143497383778564571443;
    uint256 constant IC26y = 9180356701301973095640773523610057337477696927340061683931506183686113848826;
    
    uint256 constant IC27x = 18202844052268461556416340600220633968458516717080079816583336691649309069378;
    uint256 constant IC27y = 11978384663644997244320738410049699113313538217655824128668397436299528171984;
    
    uint256 constant IC28x = 18526349627879294937279113787559697632728853774866816023970443840711930079986;
    uint256 constant IC28y = 14794659753285134137683186172595721012970052093736624947580594391232767828837;
    
    uint256 constant IC29x = 21315230340549433797940096956498545340282532943947448147220551269936395234383;
    uint256 constant IC29y = 15322143408136039575614998596402941606216619110800742965734377763598445888577;
    
    uint256 constant IC30x = 3084384750719469918762463432812801875772666740397837587871554107566064520533;
    uint256 constant IC30y = 999005601220942684684701006626834858857288750265458497142618114473390321467;
    
    uint256 constant IC31x = 4170477772886137311017376686838724450408023150512336005136429859039778389638;
    uint256 constant IC31y = 13029834605406042467000724873956439766897013550726839517901185004834295236667;
    
    uint256 constant IC32x = 19906916270223493705590104154744019352644419476072118738290884696893427583349;
    uint256 constant IC32y = 7376375179982262966715991378801540568981957648279748580890225629604232186120;
    
    uint256 constant IC33x = 21571981872774359532368746702999584816731230946126836790899100435074725840729;
    uint256 constant IC33y = 8392910258477795995051854805088607767280567447383003655689254178235151619358;
    
    uint256 constant IC34x = 4208963250498857516395277379300074401890951089741483398592184274874859478305;
    uint256 constant IC34y = 11386133995365653471398237867539667596747557585364124353946642625879013468122;
    
    uint256 constant IC35x = 17574519406218986313827491573042332234795707627495448215129889081373763370379;
    uint256 constant IC35y = 15962199197862676282957461696252192322173478865650638082161802367631360071333;
    
    uint256 constant IC36x = 594200990146884924732271249413213986266535226001253567505410198194544070602;
    uint256 constant IC36y = 15279518296325182193858687474844910880104109174302509017461123408216641264282;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[36] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
