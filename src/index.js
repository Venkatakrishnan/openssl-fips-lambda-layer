import crypto from 'crypto'
export const handler = async (event, context) => {
    const fipsVal = crypto.getFips();
    console.log(`Fips enabled ${fipsVal == 1}`);
}