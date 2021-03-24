import Koa from 'koa'
import Router from '@koa/router'
import puppeteer, { PDFOptions } from 'puppeteer'

const PORT = process.env.PORT || 3000

const app = new Koa()
const router = new Router()

router.get('/', async ctx => {
    // pdf options
    if (typeof ctx.query.url !== 'string') {
        ctx.status = 400
        ctx.body = 'Please provide a URL. Example: ?url=https://example.com'
        return
    }
    const url = ctx.query.url as string
    const landscape: boolean = ctx.query.landscape
        ? Boolean(ctx.query.landscape)
        : false
    const format: PDFOptions['format'] = ctx.query.format
        ? String(ctx.query.format) as PDFOptions['format']
        : 'a4'

    // browser
    const browser = await puppeteer.launch({
        dumpio: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    })

    // PDF
    const page = await browser.newPage();
    await page.goto(url, { waitUntil: 'networkidle0' });
    const pdf = await page.pdf({
        printBackground: true,
        landscape,
        format
    });
    await browser.close();

    // response
    ctx.type = 'application/pdf'
    ctx.body = pdf
})

app
    .use(router.routes())
    .use(router.allowedMethods())

app.listen(PORT, () => console.log(`App is listening on port ${PORT}!`))