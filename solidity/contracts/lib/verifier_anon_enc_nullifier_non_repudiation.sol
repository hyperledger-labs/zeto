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

    
    uint256 constant IC0x = 61152201537889926275975451868492796646122446807695713296456978247249582416;
    uint256 constant IC0y = 9695648204016070781622666667584047424682889351813380418002919727735680431848;
    
    uint256 constant IC1x = 10818413718893848808402545727883654427504377656024608710124673989981283454777;
    uint256 constant IC1y = 14701970259579375859890335270676117743373026657357926310435717690639139050640;
    
    uint256 constant IC2x = 9840109243993106315091706083155776361032307023052778294772503086667107815996;
    uint256 constant IC2y = 21421479189014038406783263969703640720651565849997847849843209205588964320102;
    
    uint256 constant IC3x = 12196519179633826522602326841852965755022289891906762572351016836798858206098;
    uint256 constant IC3y = 21412982233376624982950908408194070113939028694796250687285586821383910088647;
    
    uint256 constant IC4x = 7235581190969404642674908755082149965058521362907161333566312285819042633598;
    uint256 constant IC4y = 6931782325900735400905731567130246797576747310426631700865748776636338594767;
    
    uint256 constant IC5x = 17173127509734661798214022591915764018115836414873628492024583620042432609703;
    uint256 constant IC5y = 11053567531734874125107501562108570466815783441341452166837816067812005570598;
    
    uint256 constant IC6x = 21322229154496451310781618984685530972033329595022238631018620297371680426022;
    uint256 constant IC6y = 7388749448350962125829245020456825870275144349454024855495165941982341148301;
    
    uint256 constant IC7x = 3662204837926956638674706277742975228880114760813672260168091215011178377018;
    uint256 constant IC7y = 21256710106786993659486690926211319492336214639483222643807507892624155511837;
    
    uint256 constant IC8x = 16416424487929438802815037726775677877790769889611866329026773729069676481190;
    uint256 constant IC8y = 19785498286057309459570388602549762654841028364369156080553734005085711769135;
    
    uint256 constant IC9x = 3487720661542272985378587516835961797059090111389323525709549840624484697614;
    uint256 constant IC9y = 9086284871543196624528653219516125160115487238452508593981701258865845917119;
    
    uint256 constant IC10x = 18253627212668420590014153250663082604494945345432034082183424497743446495887;
    uint256 constant IC10y = 18885892320384992450879558642426510373395491929091207152085524010308391329263;
    
    uint256 constant IC11x = 414951092005304150207393545724488327983772155278396477138998452800148473396;
    uint256 constant IC11y = 20390659272138664715535171789663124592069290821350218548186974176668587653702;
    
    uint256 constant IC12x = 1168575149185240211324888653868923894417382761378342118701161407010633670253;
    uint256 constant IC12y = 4706411267945777685285850214173533798828174918633689637694953529725440534791;
    
    uint256 constant IC13x = 2708079734316722651536743890186401451097080895975517317451013107038247821480;
    uint256 constant IC13y = 8977358116889422548878836900019923323513018742753199736419453246514956562282;
    
    uint256 constant IC14x = 14554013898775641489762497185197550189632522830895044082161659057640931772313;
    uint256 constant IC14y = 14889482653403760930884332940306178418612364394102374456894952099223376786830;
    
    uint256 constant IC15x = 17631257501386282999336267319522575091683306188832359641853067203323908074688;
    uint256 constant IC15y = 10615533054645729953317855789126996302922886998690919996970038510603834128347;
    
    uint256 constant IC16x = 8897432937336003372807056990365114855955385048457406053197873363788354880005;
    uint256 constant IC16y = 15495321263778104158978910688387535214246249760036312084039296565160541778498;
    
    uint256 constant IC17x = 17086577629138371227124213198427084810777680166485068873604751243294342243364;
    uint256 constant IC17y = 2640178595987583846574831316748354322347157846109908443707128260937216710831;
    
    uint256 constant IC18x = 16132408164886035123611840951332115843280225485704624516330514903402244033844;
    uint256 constant IC18y = 14202215506801408940555491892923501280472863665075679903230018610497055124407;
    
    uint256 constant IC19x = 11075384166226685133901189117990358459979678656090407099645665784140519446199;
    uint256 constant IC19y = 10268254657997113972405744160462847515017885202341772715624667438104613841401;
    
    uint256 constant IC20x = 16557253902183535088299722558553861661224436217793266741175101452533738391452;
    uint256 constant IC20y = 20745617385071117222395337373235588040367724445790169286930647533849729207393;
    
    uint256 constant IC21x = 20276608125826464320376441606771761357230362470337215016714387155148950666599;
    uint256 constant IC21y = 17239242738104373845790998232385943645662169711985953967303958257047014479471;
    
    uint256 constant IC22x = 5468803742491520170652456835172480096975199763110920011227423237939965120207;
    uint256 constant IC22y = 10174598386076821485585800465159883129504130989583486981573994868686379305592;
    
    uint256 constant IC23x = 16599048882137769684318845208760094357578011339397607490719154542208418938756;
    uint256 constant IC23y = 13707639706540078382732652651030837558499924834000166193089217038693941304921;
    
    uint256 constant IC24x = 15500365059494035595313116884299889945654503047189092046213356892620745679761;
    uint256 constant IC24y = 3011251002372418632018519536826417868656538639481362934022721707993634028436;
    
    uint256 constant IC25x = 7753191558285517673913730304558808219026687470773211539615140473091639976801;
    uint256 constant IC25y = 21027943544731468810145211491708040194061275482321933619845807595195830153424;
    
    uint256 constant IC26x = 15960757957822522316310966391345985404864097297323560625516737351925975813261;
    uint256 constant IC26y = 4347910655717154598004544319915545683055553526828690820284353401002638182272;
    
    uint256 constant IC27x = 2046647242310270851768817892706457764601280100679956790044440377297878085576;
    uint256 constant IC27y = 21309641850717155775706239210200211893388849300806309076190017272113498323810;
    
    uint256 constant IC28x = 19597691291777789593490660411582938308337232089021256869678006625229616548796;
    uint256 constant IC28y = 13820011893561492651702294225486438195332162240104655125561826839247672430721;
    
    uint256 constant IC29x = 21851557989147907820650966779309613501892960294400269160320917010221513281109;
    uint256 constant IC29y = 12557462194610933903124929702503099769284858185996077647536148067635397338991;
    
    uint256 constant IC30x = 12207189225721994604952937615696899377442678839226083655403720663235093461689;
    uint256 constant IC30y = 15830428763679240451172816453919204017985215066319417687539454241048626278967;
    
    uint256 constant IC31x = 4081908059095427843697493043351639450365605703110409523961207174007236484594;
    uint256 constant IC31y = 21548923288877200209583216684211078344630771042900720710385747398692491519215;
    
    uint256 constant IC32x = 13856212562239399663932100593091486718740554719127709669526649747051185213477;
    uint256 constant IC32y = 11606635826446787988089212546591198489112765060900712690193434214630560210183;
    
    uint256 constant IC33x = 6886077838878155423222525820388792351764063548264896251770137531272491984160;
    uint256 constant IC33y = 11751057318610310230818395934629656703134727241242152533660390881350105654273;
    
    uint256 constant IC34x = 4922806362911026274177971239322411824999727481356932313866779043681978928813;
    uint256 constant IC34y = 1647157187422345530281186342478775664173617309478642934298471295512051621981;
    
    uint256 constant IC35x = 6143994621664212907952117049980707194193475458802305382424783593007363457106;
    uint256 constant IC35y = 8200689963763708865676511179816670550341929963040776220149093434181834590060;
    
    uint256 constant IC36x = 10255139971908934264949047378713233471192075842841114250056065579445305987705;
    uint256 constant IC36y = 18935081644016507039588454984092027149059279175474401447588285789996499051430;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
