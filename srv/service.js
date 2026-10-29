import cds from '@sap/cds'
import { SELECT, UPDATE, INSERT } from '@sap/cds/lib/ql/cds-ql.js'

export default class ServiceDesk extends cds.ApplicationService {

    init() {

        const { Incidentes, Conversas } = this.entities

        this.on('fecharIncidente', async req => {

            const incidenteID = req.params[0].ID

            const incidente = await SELECT.one
                .from(Incidentes)
                .where({ ID: incidenteID })

            if (!incidente.descricaoResolucao) {
                req.reject('Informe a resolução antes de fechar o incidente!')
            }

            await UPDATE(Incidentes)
                .set({
                    status_codigo: 'F',
                    dataFechamento: new Date()
                })
                .where({ ID: incidenteID })

            await INSERT.into(Conversas).entries({
                mensagem: 'Incidente fechado.',
                incidente_ID: incidenteID,
                cliente_ID: '99999999-9999-9999-9999-999999999999'
            })

        })

        this.on('reabrirIncidente', async req => {

            const incidenteID = req.params[0].ID

            await UPDATE(Incidentes)
                .set({
                    status_codigo: 'P',
                    dataFechamento: null
                })
                .where({ ID: incidenteID })

            await INSERT.into(Conversas).entries({
                mensagem: 'Incidente reaberto.',
                incidente_ID: incidenteID,
                cliente_ID: '99999999-9999-9999-9999-999999999999'
            })

        })

        this.before('CREATE', Incidentes, async req => {

            if (!req.data.status_codigo) {
                req.data.status_codigo = 'N'
            }

        })

        this.before('UPDATE', Incidentes, async req => {

            const incidente = await SELECT.one
                .from(Incidentes)
                .where({ ID: req.data.ID })

            if (incidente?.status_codigo === 'F') {
                req.reject(
                    'Incidentes fechados não podem ser alterados. Reabra o incidente primeiro.'
                )
            }

            if (
                req.data.status_codigo === 'F' &&
                !req.data.descricaoResolucao
            ) {
                req.reject(
                    'Informe a resolução antes de fechar o incidente!'
                )
            }

            if (req.data.status_codigo === 'F') {
                req.data.dataFechamento = new Date()
            }

            if (
                req.data.status_codigo &&
                req.data.status_codigo !== 'F'
            ) {
                req.data.dataFechamento = null
            }

        })

        return super.init()
    }

}