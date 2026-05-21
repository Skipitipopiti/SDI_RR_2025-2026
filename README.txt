# FMC Memory Interface Controller

Modulo hardware progettato per interfacciare il protocollo di un bus **FMC (Flexible Memory Controller)** esterno (STM32L496) con un'unità di memoria asincrona locale, disaccoppiando i domini temporali e garantendo la stabilità dei dati.

---

## 📐 Architettura (CU + DP)

L'interfaccia adotta una scomposizione classica **FSM + Datapath**:
* **Control Unit (FMC_CU):** Gestisce la macchina a stati finiti, campiona le linee dal microcontroller e genera i segnali di enable sequenziali e di controllo Tri-State.
* **Data Path (FMC_DP):** Implementa i registri intermedi di isolamento:
  * **Registro A:** Mantiene l'indirizzo dal bus congiunto.
  * **Registro Dout:** Registra il dato da scrivere in memoria.
  * **Registro Din:** Isolato tramite buffer Tri-State (`Din_OE`), gestisce i dati letti verso il bus esterno.

---

## ⏱️ Ripartizione dei Fronti di Clock

Per garantire i margini di setup e hold, i fronti di clock sono così suddivisi:
* **Fronte di Discesa (Falling Edge):** Bus FMC esterno e registro di ingresso dati `Din`.
* **Fronte di Salita (Rising Edge):** Memoria interna, registro indirizzi `A` e registro dati in uscita `Dout`.

### Sincronizzazione Chip Select (`NE1`)
Poiché la stabilità di `NE` non è garantita sul fronte di discesa iniziale dal datasheet, è stato introdotto un **Flip-Flop di campionamento sul fronte di salita** (generando il segnale interno `NE_rs`). Questo Flip-Flop viene abilitato (`NE_rs_en`) esclusivamente nello stato di `IDLE` per prevenire fenomeni di metastabilità a inizio ciclo.

---

## 🔄 Evoluzione della FSM

1. **`IDLE` $\rightarrow$ `GET ADDR`:** All'attivazione di `NE_rs`, la FSM passa a `GET ADDR` abilitando `A_En` per salvare l'indirizzo. In questo stato il campionamento di `NWE` determina la direzione del ciclo (Scrittura se basso, Lettura se alto).
2. **Ciclo di Lettura (`MEM READ`):** Attivazione di `CS` e `RD` verso la memoria. Il microcontroller asserisce `NOE` attivando il buffer Tri-State (`Din_OE`). Il dato viene sostenuto (*stretch*) fino al rilascio di `NE`, che riporta la macchina in `IDLE`.
3. **Ciclo di Scrittura (`WAIT` $\rightarrow$ `SAMPLE` $\rightarrow$ `SAMPLE & WRITE` $\rightarrow$ `WRITE`):** Inserisce uno stato di `WAIT` normativo, esegue il campionamento del dato d'ingresso in `SAMPLE` (`Dout_En`) e avvia la scrittura in memoria in `SAMPLE & WRITE` (`CS` e `WR` attivi). La struttura in pipeline permette lo *stretch* del ciclo finché `NE` e `NWE` rimangono asseriti.
