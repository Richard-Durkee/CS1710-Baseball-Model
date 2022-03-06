const Base1 = firstBase
const Base2 = secondBase
const Base3 = thirdBase
const emptyBase = noRunner

const plate_url = 'https://www.pngkey.com/png/detail/45-450794_baseball-home-plate-clip-art-vector-free-library.png'
const runner_url = 'https://www.pngkey.com/png/detail/4-46672_new-player-red-baseball-hat-baseball-cap-clipart.png'

function make_img(url) {
    const img = document.createElement('img')
    img.src = url
    img.style.width = '20%'
    img.style.border = '1x solid black'
    img.style.position = 'absolute'

    return img;
}

div.replaceChildren() // remove all content

let state = AtBat;
while (next.join(state).tuples().length > 0) {
    state = next.join(state)
}
let i = 0;
do {
    // const pre = state;
    // const post = state.join(next)

    function make_base(base) {
        const div = document.createElement('div')
        div.style.width = '100%'
        div.style.height = '100%'
        div.style['margin-right'] = '1%'
        div.style['margin-left'] = '1%'
        div.style.position = 'absolute'

        const on_base = state.join(base.join(runner)).toString().includes(emptyBase.toString())

        let img_url = plate_url;
        if (!on_base) {
            img_url = runner_url
        }

        div.appendChild(make_img(img_url))

        return div
    }

    const Base1_div = make_base(Base1)

    const Base2_div = make_base(Base2)

    const Base3_div = make_base(Base3)

    Base1_div.style.display = 'flex'
    Base3_div.style.display = 'flex'
    Base1_div.style.flexDirection = 'column'
    Base3_div.style.flexDirection = 'column'
    Base1_div.style.justifyContent = 'center'
    Base3_div.style.justifyContent = 'center'
    Base3_div.style.left = '15%'
    Base1_div.style.left = '65%'

    Base2_div.style.left = '40%'

    // const batter_div = make_batter(base)

    const pree = document.createElement('pre')
    pree.style.width = '200px'
    pree.style.height = '200px'
    pree.style.margin = '1%'
    pree.style.padding = '0.5em'
    pree.style.border = '1px solid black'
    pree.style.display = 'inline-block'
    pree.style.color = 'green'
    pree.style["background-color"] = 'green'
    pree.style.position = 'relative'

    pree.appendChild(Base1_div)
    pree.appendChild(Base2_div)
    pree.appendChild(Base3_div)

    div.appendChild(pree)

    state = state.join(next);
    i++;
} while (state.tuples()[0]);
